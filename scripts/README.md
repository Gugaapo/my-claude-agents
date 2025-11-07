# Backup Scripts

Automated scripts for backing up Claude Code agents to this Git repository.

## Available Scripts

### Linux/Mac: `backup-agents-linux.sh`

Bash script for Linux and macOS systems.

**Usage:**
```bash
cd ~/my-claude-agents
./scripts/backup-agents-linux.sh
```

**What it does:**
1. Backs up all global agents from `~/.claude/agents/`
2. Searches for and backs up project-specific agents
3. Commits changes to Git with timestamp
4. Provides option to push to remote repository

**Setup automatic backups (optional):**

Add to your crontab to run daily at 2 AM:
```bash
crontab -e

# Add this line:
0 2 * * * $HOME/my-claude-agents/scripts/backup-agents-linux.sh >> /tmp/claude-agent-backup.log 2>&1
```

### Windows: `backup-agents-windows.ps1`

PowerShell script for Windows systems.

**Usage:**
```powershell
cd $env:USERPROFILE\my-claude-agents
.\scripts\backup-agents-windows.ps1
```

**What it does:**
1. Backs up all global agents from `%USERPROFILE%\.claude\agents\`
2. Searches for and backs up project-specific agents
3. Commits changes to Git with timestamp
4. Provides option to push to remote repository

**Setup automatic backups (optional):**

Use Task Scheduler to run daily:

1. Open Task Scheduler
2. Create Basic Task
3. Name: "Claude Agent Backup"
4. Trigger: Daily at 2:00 AM
5. Action: Start a program
   - Program: `powershell.exe`
   - Arguments: `-ExecutionPolicy Bypass -File "C:\Users\<username>\my-claude-agents\scripts\backup-agents-windows.ps1"`
6. Finish

## Customization

### Adding Project Directories

Edit the scripts to include your project directories:

**Linux (`backup-agents-linux.sh`):**
```bash
PROJECT_DIRS=(
    "$HOME/TJAM/arandu-api"
    "$HOME/projects/my-other-project"
    "$HOME/work/client-project"
)
```

**Windows (`backup-agents-windows.ps1`):**
```powershell
$ProjectDirs = @(
    "$env:USERPROFILE\TJAM\arandu-api",
    "$env:USERPROFILE\projects\my-other-project",
    "$env:USERPROFILE\work\client-project"
)
```

### Enabling Remote Push

Both scripts have remote push commented out by default. To enable:

1. Add a remote repository:
   ```bash
   cd ~/my-claude-agents  # or Windows equivalent
   git remote add origin <your-repository-url>
   ```

2. Uncomment the push section in the script:

   **Linux:**
   ```bash
   # Find these lines and uncomment them:
   # echo ""
   # echo -e "${YELLOW}Step 4: Pushing to remote...${NC}"
   # if git remote get-url origin >/dev/null 2>&1; then
   #     git push origin main && echo -e "${GREEN}✓ Pushed to remote${NC}" || echo -e "${YELLOW}⚠ Failed to push to remote${NC}"
   # else
   #     echo -e "${YELLOW}⚠ No remote configured. Skipping push.${NC}"
   #     echo "To add a remote: git remote add origin <repository-url>"
   # fi
   ```

   **Windows:**
   ```powershell
   # Find these lines and uncomment them:
   # Write-Host ""
   # Write-Host "Step 4: Pushing to remote..." -ForegroundColor Yellow
   # $RemoteExists = git remote get-url origin 2>$null
   # if ($RemoteExists) {
   #     git push origin main
   #     ...
   # }
   ```

## Manual Backup

If you prefer manual backups without using these scripts:

**Linux/Mac:**
```bash
cd ~/my-claude-agents
cp ~/.claude/agents/* global-agents/
git add .
git commit -m "Manual backup: $(date +%Y-%m-%d)"
git push origin main
```

**Windows:**
```powershell
cd $env:USERPROFILE\my-claude-agents
Copy-Item "$env:USERPROFILE\.claude\agents\*" "global-agents\" -Force
git add .
git commit -m "Manual backup: $(Get-Date -Format 'yyyy-MM-dd')"
git push origin main
```

## Troubleshooting

### Script Execution Errors (Linux)

**Permission denied:**
```bash
chmod +x scripts/backup-agents-linux.sh
```

**Command not found (git):**
```bash
sudo apt-get install git  # Debian/Ubuntu
```

### Script Execution Errors (Windows)

**Execution policy error:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Git not found:**
Install Git for Windows from https://git-scm.com/download/win

### No Changes to Commit

This is normal if you haven't modified any agents since the last backup. The script will skip the commit step.

### Remote Push Fails

**Authentication error:**
- Set up SSH keys or use HTTPS with credential caching
- For GitHub: Use Personal Access Token instead of password

**Remote not configured:**
```bash
git remote add origin <your-repository-url>
```

## Best Practices

1. **Run backups regularly** - Set up automated backups or run manually after agent modifications
2. **Test restoration** - Periodically test restoring from backup on a test system
3. **Use remote repository** - Push to GitHub/GitLab for off-machine backup
4. **Version control** - Use meaningful commit messages for manual backups
5. **Review logs** - Check automated backup logs periodically for errors

## Backup Schedule Recommendations

- **Development machine**: Daily backups
- **Stable agents**: Weekly backups
- **After modifications**: Immediate manual backup
- **Before major changes**: Manual backup with descriptive commit message

---

Last updated: 2025-11-07
