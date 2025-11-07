# Claude Code Custom Agents Backup

This repository contains a backup of all custom Claude Code agents for easy portability across different machines and operating systems.

## Repository Structure

```
claude-agent-backups/
├── global-agents/          # System-wide agents (available in all projects)
├── project-agents/         # Project-specific agents
│   └── arandu-api/        # Agents for the Arandu API project
├── scripts/               # Backup and restoration scripts
├── README.md             # This file
├── INSTALL.md            # Installation instructions
└── .gitattributes        # Git configuration for cross-platform compatibility
```

## Global Agents (15 Active)

Available system-wide across all projects:

- **agent-manager** - Intelligent task router for specialized agents
- **api-architect** - API design and architecture specialist
- **data-pipeline-architect** - Data processing and pipeline design
- **dev-env-manager** - Development environment setup and management
- **documentation-expert** - Documentation creation and maintenance
- **git-operations-expert** - Complex Git operations and workflows
- **homelab-research-expert** - Homelab and self-hosting guidance
- **linux-sysadmin-expert** - Linux system administration
- **pc-hardware-advisor-br** - PC hardware advice for Brazilian market
- **performance-monitor** - Performance optimization and monitoring
- **prompt-architect** - AI prompt engineering and optimization
- **requirements-analyst** - Requirements elicitation and documentation
- **research-assistant** - Research and information gathering
- **security-auditor** - Security auditing and vulnerability assessment
- **software-architect** - Software architecture and project design

## Project-Specific Agents

### Arandu API Project
- **project-engineer** - Specialist in Arandu API codebase
- **agent-manager** - Project-specific override

## Quick Start

### Linux/Mac Installation
```bash
# Install global agents
mkdir -p ~/.claude/agents
cp global-agents/* ~/.claude/agents/

# Install project agents (optional)
cd /path/to/your/project
mkdir -p .claude/agents
cp /path/to/backup/project-agents/arandu-api/* .claude/agents/
```

### Windows Installation
```powershell
# Install global agents
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\agents"
Copy-Item -Path "global-agents\*" -Destination "$env:USERPROFILE\.claude\agents\" -Recurse

# Install project agents (optional)
cd C:\path\to\your\project
New-Item -ItemType Directory -Force -Path ".claude\agents"
Copy-Item -Path "project-agents\arandu-api\*" -Destination ".claude\agents\" -Recurse
```

## Detailed Instructions

See [INSTALL.md](INSTALL.md) for detailed platform-specific installation instructions.

## Backup Strategy

This repository uses Git for version control, providing:
- Complete version history of agent evolution
- Easy restoration on any platform (Windows, Linux, macOS)
- Disaster recovery with remote backups
- Collaboration capability

## Automated Backups

Use the provided scripts in the `scripts/` directory:
- **Linux**: `scripts/backup-agents-linux.sh`
- **Windows**: `scripts/backup-agents-windows.ps1`

## Maintenance

### Updating Agents
After modifying agents on your local system:
```bash
# Copy updated agents
cp ~/.claude/agents/* global-agents/

# Commit changes
git add .
git commit -m "Update: [describe changes]"
git push
```

### Restoring on New Machine
```bash
git clone <repository-url>
cd claude-agent-backups
# Follow installation instructions above
```

## Cross-Platform Compatibility

All agents are designed to work on:
- Debian-based Linux distributions
- Windows 10/11
- macOS (not specifically tested but should work)

Path handling and line endings are configured for cross-platform compatibility.

## License

These are personal custom agents for Claude Code. Use and modify as needed for your own purposes.

## Last Updated

2025-11-07
