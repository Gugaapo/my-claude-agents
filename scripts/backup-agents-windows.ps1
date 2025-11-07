# Automated backup script for Claude Code agents (Windows PowerShell)
# This script backs up your agents to the Git repository

# Configuration
$BackupDir = "$env:USERPROFILE\my-claude-agents"
$GlobalAgentsDir = "$env:USERPROFILE\.claude\agents"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "=== Claude Code Agent Backup Script ===" -ForegroundColor Green
Write-Host "Timestamp: $Timestamp"
Write-Host ""

# Check if backup directory exists
if (-not (Test-Path $BackupDir)) {
    Write-Host "Error: Backup directory not found at $BackupDir" -ForegroundColor Red
    Write-Host "Please initialize the repository first."
    exit 1
}

# Check if global agents directory exists
if (-not (Test-Path $GlobalAgentsDir)) {
    Write-Host "Error: Global agents directory not found at $GlobalAgentsDir" -ForegroundColor Red
    Write-Host "No agents to backup."
    exit 1
}

# Navigate to backup directory
Push-Location $BackupDir

try {
    Write-Host "Step 1: Backing up global agents..." -ForegroundColor Yellow

    # Ensure global-agents directory exists
    if (-not (Test-Path "global-agents")) {
        New-Item -ItemType Directory -Path "global-agents" | Out-Null
    }

    # Copy global agents
    Copy-Item "$GlobalAgentsDir\*" "global-agents\" -Force -Recurse -ErrorAction Stop
    Write-Host "✓ Global agents backed up" -ForegroundColor Green

    # Check for project agents in common locations
    Write-Host ""
    Write-Host "Step 2: Checking for project agents..." -ForegroundColor Yellow

    # List of project directories to check (customize as needed)
    $ProjectDirs = @(
        "$env:USERPROFILE\TJAM\arandu-api",
        "$env:USERPROFILE\projects\*"
        # Add more project paths here as needed
    )

    $ProjectCount = 0
    foreach ($ProjectPattern in $ProjectDirs) {
        $Projects = Get-Item $ProjectPattern -ErrorAction SilentlyContinue

        foreach ($ProjectDir in $Projects) {
            $AgentsPath = Join-Path $ProjectDir.FullName ".claude\agents"

            if (Test-Path $AgentsPath) {
                $ProjectName = $ProjectDir.Name
                Write-Host "Found project agents in: $ProjectName"

                # Create project agents directory if needed
                $ProjectBackupPath = "project-agents\$ProjectName"
                if (-not (Test-Path $ProjectBackupPath)) {
                    New-Item -ItemType Directory -Path $ProjectBackupPath | Out-Null
                }

                # Copy project agents
                Copy-Item "$AgentsPath\*" $ProjectBackupPath -Force -Recurse -ErrorAction SilentlyContinue

                $ProjectCount++
            }
        }
    }

    if ($ProjectCount -eq 0) {
        Write-Host "No project agents found"
    } else {
        Write-Host "✓ Backed up agents from $ProjectCount project(s)" -ForegroundColor Green
    }

    # Git operations
    Write-Host ""
    Write-Host "Step 3: Committing to Git..." -ForegroundColor Yellow

    # Check if git is initialized
    if (-not (Test-Path ".git")) {
        Write-Host "Git not initialized. Initializing now..." -ForegroundColor Yellow
        git init
        git branch -m main
    }

    # Add all changes
    git add .

    # Check if there are changes to commit
    $HasChanges = git diff --cached --quiet
    if ($LASTEXITCODE -eq 0) {
        Write-Host "No changes to commit - agents are already up to date"
    } else {
        # Count changed files
        $ChangedFiles = (git diff --cached --name-only | Measure-Object).Count

        # Count agent files
        $GlobalAgentCount = (Get-ChildItem "global-agents\*.md" -ErrorAction SilentlyContinue | Measure-Object).Count

        # Create commit message
        $CommitMessage = @"
Automated backup: $Timestamp

- Updated $ChangedFiles file(s)
- Global agents: $GlobalAgentCount
- Project agents: $ProjectCount project(s)
"@

        git commit -m $CommitMessage

        Write-Host "✓ Changes committed successfully" -ForegroundColor Green
        Write-Host "Changed files: $ChangedFiles"
    }

    # Optional: Push to remote (uncomment if you have a remote configured)
    # Write-Host ""
    # Write-Host "Step 4: Pushing to remote..." -ForegroundColor Yellow
    # $RemoteExists = git remote get-url origin 2>$null
    # if ($RemoteExists) {
    #     git push origin main
    #     if ($LASTEXITCODE -eq 0) {
    #         Write-Host "✓ Pushed to remote" -ForegroundColor Green
    #     } else {
    #         Write-Host "⚠ Failed to push to remote" -ForegroundColor Yellow
    #     }
    # } else {
    #     Write-Host "⚠ No remote configured. Skipping push." -ForegroundColor Yellow
    #     Write-Host "To add a remote: git remote add origin <repository-url>"
    # }

    Write-Host ""
    Write-Host "=== Backup Complete ===" -ForegroundColor Green
    Write-Host "Location: $BackupDir"
    Write-Host "Timestamp: $Timestamp"
    Write-Host ""
    Write-Host "To push to remote repository, run:"
    Write-Host "  cd $BackupDir; git push origin main"

} catch {
    Write-Host "Error during backup: $_" -ForegroundColor Red
    exit 1
} finally {
    Pop-Location
}
