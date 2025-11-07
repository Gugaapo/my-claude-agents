# Agent Installation Guide

Complete instructions for installing Claude Code custom agents across different platforms.

## Prerequisites

- Claude Code must be installed and configured
- Git (for cloning this repository)
- Terminal/Command Prompt/PowerShell access

## Installation Paths

### Linux/Mac
- **Global agents**: `~/.claude/agents/`
- **Project agents**: `<project-root>/.claude/agents/`

### Windows
- **Global agents**: `C:\Users\<username>\.claude\agents\`
- **Project agents**: `<project-root>\.claude\agents\`

---

## Linux/Debian Installation

### Step 1: Clone Repository

```bash
cd ~
git clone https://github.com/Gugaapo/my-claude-agents.git
cd my-claude-agents
```

### Step 2: Install Global Agents

```bash
# Create directory if it doesn't exist
mkdir -p ~/.claude/agents

# Copy all global agents
cp global-agents/* ~/.claude/agents/

# Set proper permissions
chmod 755 ~/.claude/agents
chmod 644 ~/.claude/agents/*.md
```

### Step 3: Verify Installation

```bash
# List installed agents
ls -la ~/.claude/agents/

# Count agents (should be 17 including deprecated ones)
ls ~/.claude/agents/*.md | wc -l
```

### Step 4: Install Project-Specific Agents (Optional)

```bash
# Navigate to your project
cd /path/to/your/project

# Create project agents directory
mkdir -p .claude/agents

# Copy project agents (example: arandu-api)
cp ~/my-claude-agents/project-agents/arandu-api/* .claude/agents/

# Set permissions
chmod 755 .claude/agents
chmod 644 .claude/agents/*.md
```

### Step 5: Test Agent Discovery

Open Claude Code in your project and verify agents are available:
```bash
# Start Claude Code and ask:
# "What custom agents are available?"
```

---

## Windows Installation

### Step 1: Clone Repository

Open PowerShell:

```powershell
cd $env:USERPROFILE
git clone https://github.com/Gugaapo/my-claude-agents.git
cd my-claude-agents
```

### Step 2: Install Global Agents

```powershell
# Create directory if it doesn't exist
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\agents"

# Copy all global agents
Copy-Item -Path "global-agents\*" -Destination "$env:USERPROFILE\.claude\agents\" -Recurse -Force

# Verify files are not read-only
Get-ChildItem "$env:USERPROFILE\.claude\agents" -Recurse | ForEach-Object { $_.IsReadOnly = $false }
```

### Step 3: Verify Installation

```powershell
# List installed agents
Get-ChildItem "$env:USERPROFILE\.claude\agents"

# Count agents
(Get-ChildItem "$env:USERPROFILE\.claude\agents\*.md").Count
```

### Step 4: Install Project-Specific Agents (Optional)

```powershell
# Navigate to your project
cd C:\path\to\your\project

# Create project agents directory
New-Item -ItemType Directory -Force -Path ".claude\agents"

# Copy project agents (example: arandu-api)
Copy-Item -Path "$env:USERPROFILE\my-claude-agents\project-agents\arandu-api\*" -Destination ".claude\agents\" -Recurse -Force
```

### Step 5: Test Agent Discovery

Open Claude Code in your project and verify agents are available.

---

## macOS Installation

Follow the Linux instructions above. macOS uses the same paths as Linux:
- Global: `~/.claude/agents/`
- Project: `<project>/.claude/agents/`

---

## Troubleshooting

### Agents Not Appearing

**Check directory exists:**
```bash
# Linux/Mac
ls -la ~/.claude/agents/

# Windows
dir %USERPROFILE%\.claude\agents
```

**Check file permissions (Linux/Mac):**
```bash
# Files should be readable
ls -la ~/.claude/agents/
# Fix permissions if needed
chmod 644 ~/.claude/agents/*.md
```

**Check file encoding:**
- All agent files should be UTF-8 encoded
- Check for BOM (Byte Order Mark) - remove if present

### Path Issues

**Linux/Mac:**
- Ensure you're using absolute paths or proper home directory expansion
- `~/.claude/agents/` should expand to `/home/username/.claude/agents/`

**Windows:**
- Ensure backslashes are properly escaped in scripts
- Use environment variables: `%USERPROFILE%\.claude\agents`
- Check path length (Windows has 260 character limit)

### Git Line Ending Issues

If agents appear corrupted after cloning:

```bash
# Check current line endings
file ~/.claude/agents/*.md

# Should show: "ASCII text" or "UTF-8 Unicode text"
# Should NOT show: "with CRLF line terminators" on Linux
```

Fix by re-cloning with proper line ending configuration:
```bash
git config --global core.autocrlf input  # Linux/Mac
git config --global core.autocrlf true   # Windows
```

### Permission Denied (Linux/Mac)

```bash
# Fix ownership
sudo chown -R $USER:$USER ~/.claude/agents/

# Fix permissions
chmod 755 ~/.claude/agents
chmod 644 ~/.claude/agents/*.md
```

### Claude Code Not Recognizing Agents

1. Restart Claude Code
2. Check Claude Code version (ensure it's up to date)
3. Verify agent file format (must be `.md` files with proper frontmatter if required)
4. Check Claude Code logs for errors

---

## Updating Agents

### Pull Latest Changes

```bash
# Linux/Mac/Windows (Git Bash or PowerShell)
cd ~/my-claude-agents  # or %USERPROFILE%\my-claude-agents on Windows
git pull origin main

# Re-run installation steps to update agents
```

### Manual Update

If you modified agents locally:

**Linux/Mac:**
```bash
cd ~/my-claude-agents
cp ~/.claude/agents/* global-agents/
git add .
git commit -m "Update agents from local changes"
git push
```

**Windows:**
```powershell
cd $env:USERPROFILE\my-claude-agents
Copy-Item "$env:USERPROFILE\.claude\agents\*" "global-agents\" -Force
git add .
git commit -m "Update agents from local changes"
git push
```

---

## Selective Installation

If you don't want all agents, install only specific ones:

**Linux/Mac:**
```bash
# Install only specific agents
cp global-agents/software-architect.md ~/.claude/agents/
cp global-agents/git-operations-expert.md ~/.claude/agents/
```

**Windows:**
```powershell
# Install only specific agents
Copy-Item "global-agents\software-architect.md" "$env:USERPROFILE\.claude\agents\"
Copy-Item "global-agents\git-operations-expert.md" "$env:USERPROFILE\.claude\agents\"
```

---

## Uninstallation

### Remove All Agents

**Linux/Mac:**
```bash
rm -rf ~/.claude/agents/*
```

**Windows:**
```powershell
Remove-Item "$env:USERPROFILE\.claude\agents\*" -Recurse -Force
```

### Remove Specific Agent

**Linux/Mac:**
```bash
rm ~/.claude/agents/agent-name.md
```

**Windows:**
```powershell
Remove-Item "$env:USERPROFILE\.claude\agents\agent-name.md"
```

---

## Migration Checklist

When setting up on a new machine:

- [ ] Install Claude Code
- [ ] Clone this repository
- [ ] Create `~/.claude/agents/` directory (or Windows equivalent)
- [ ] Copy global agents
- [ ] Set proper permissions (Linux/Mac)
- [ ] Verify installation
- [ ] Test agent discovery in Claude Code
- [ ] Install project-specific agents if needed
- [ ] Configure automated backup script (optional)

---

## Support

For issues with:
- **Claude Code**: Visit official documentation
- **These agents**: Check repository issues or documentation
- **Installation**: Review troubleshooting section above

---

Last updated: 2025-11-07
