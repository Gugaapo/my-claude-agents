#!/bin/bash
# Automated backup script for Claude Code agents (Linux)
# This script backs up your agents to the Git repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
BACKUP_DIR="$HOME/my-claude-agents"
GLOBAL_AGENTS_DIR="$HOME/.claude/agents"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo -e "${GREEN}=== Claude Code Agent Backup Script ===${NC}"
echo "Timestamp: $TIMESTAMP"
echo ""

# Check if backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}Error: Backup directory not found at $BACKUP_DIR${NC}"
    echo "Please initialize the repository first."
    exit 1
fi

# Check if global agents directory exists
if [ ! -d "$GLOBAL_AGENTS_DIR" ]; then
    echo -e "${RED}Error: Global agents directory not found at $GLOBAL_AGENTS_DIR${NC}"
    echo "No agents to backup."
    exit 1
fi

# Navigate to backup directory
cd "$BACKUP_DIR"

echo -e "${YELLOW}Step 1: Backing up global agents...${NC}"
# Copy global agents
cp -r "$GLOBAL_AGENTS_DIR"/* global-agents/ 2>/dev/null || {
    echo -e "${RED}Error: Failed to copy global agents${NC}"
    exit 1
}
echo -e "${GREEN}✓ Global agents backed up${NC}"

# Check for project agents in common locations
echo ""
echo -e "${YELLOW}Step 2: Checking for project agents...${NC}"

# List of project directories to check (customize as needed)
PROJECT_DIRS=(
    "$HOME/TJAM/arandu-api"
    # Add more project paths here as needed
)

PROJECT_COUNT=0
for PROJECT_DIR in "${PROJECT_DIRS[@]}"; do
    if [ -d "$PROJECT_DIR/.claude/agents" ]; then
        PROJECT_NAME=$(basename "$PROJECT_DIR")
        echo "Found project agents in: $PROJECT_NAME"

        # Create project agents directory if needed
        mkdir -p "project-agents/$PROJECT_NAME"

        # Copy project agents
        cp -r "$PROJECT_DIR/.claude/agents"/* "project-agents/$PROJECT_NAME/" 2>/dev/null || true

        PROJECT_COUNT=$((PROJECT_COUNT + 1))
    fi
done

if [ $PROJECT_COUNT -eq 0 ]; then
    echo "No project agents found"
else
    echo -e "${GREEN}✓ Backed up agents from $PROJECT_COUNT project(s)${NC}"
fi

# Git operations
echo ""
echo -e "${YELLOW}Step 3: Committing to Git...${NC}"

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Git not initialized. Initializing now...${NC}"
    git init
    git branch -m main
fi

# Add all changes
git add .

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "No changes to commit - agents are already up to date"
else
    # Count changed files
    CHANGED_FILES=$(git diff --cached --name-only | wc -l)

    # Create commit
    git commit -m "Automated backup: $TIMESTAMP

- Updated $CHANGED_FILES file(s)
- Global agents: $(ls -1 global-agents/*.md 2>/dev/null | wc -l)
- Project agents: $PROJECT_COUNT project(s)
"

    echo -e "${GREEN}✓ Changes committed successfully${NC}"
    echo "Changed files: $CHANGED_FILES"
fi

# Optional: Push to remote (uncomment if you have a remote configured)
# echo ""
# echo -e "${YELLOW}Step 4: Pushing to remote...${NC}"
# if git remote get-url origin >/dev/null 2>&1; then
#     git push origin main && echo -e "${GREEN}✓ Pushed to remote${NC}" || echo -e "${YELLOW}⚠ Failed to push to remote${NC}"
# else
#     echo -e "${YELLOW}⚠ No remote configured. Skipping push.${NC}"
#     echo "To add a remote: git remote add origin <repository-url>"
# fi

echo ""
echo -e "${GREEN}=== Backup Complete ===${NC}"
echo "Location: $BACKUP_DIR"
echo "Timestamp: $TIMESTAMP"
echo ""
echo "To push to remote repository, run:"
echo "  cd $BACKUP_DIR && git push origin main"
