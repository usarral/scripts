# Scripts Collection

A curated collection of useful scripts for development, automation, and system management.

**Author:** [@usarral](https://github.com/usarral)

## 📚 Collection Structure

```
scripts/
├── disk-management/          # Disk space and storage management
│   └── git-repo-cleaner/    # Clean up synced Git repositories
├── docker/                   # Docker utilities (coming soon)
├── kubernetes/               # Kubernetes helpers (coming soon)
└── utils/                    # General utilities (coming soon)
```

## 🛠️ Available Scripts

### Disk Management

#### [Git Repository Cleaner](./disk-management/git-repo-cleaner)
Analyze your work directory for synced Git repositories and safely delete local copies that are fully synchronized with their remotes. Includes a restore tool to clone them back when needed.

- **Scripts:** `free_disk_space.sh`, `restore_repos.sh`
- **Features:** JSON logging, interactive prompts, safety checks, batch restore
- **Use case:** Free up disk space by removing synced repositories while keeping the ability to restore them

## 🚀 Quick Start

### Quick Install

Run the install script to set up all available scripts:

```bash
cd ~/work/scripts
./install.sh
```

This will:
- Check requirements (bash, git, jq)
- Make all scripts executable
- Show you what's available

### Manual Setup

Each script category has its own README with detailed instructions. Navigate to the specific directory for:
- Installation instructions
- Usage examples
- Configuration options
- Troubleshooting guides

## 📋 Requirements

Common requirements across scripts:
- Bash shell (macOS/Linux)
- Git (for git-related scripts)
- `jq` for JSON processing (install with `brew install jq`)

Specific requirements are listed in each script's README.

## 🤝 Contributing

This is a personal collection of scripts I use regularly. Feel free to:
- Fork and adapt for your own use
- Report issues or suggest improvements
- Share your own scripts (via issues/discussions)

## 📄 License

MIT License - Feel free to use and modify these scripts for your own purposes.

## 💡 Philosophy

These scripts are designed with the following principles:
- **Safety First**: Always prompt before destructive actions
- **Clear Output**: Color-coded, informative messages
- **Reversible**: Provide recovery mechanisms where possible
- **Well Documented**: Comprehensive READMEs and inline comments
- **Practical**: Solve real-world problems I encounter

## 🔗 Links

- GitHub: [@usarral](https://github.com/usarral)
- Issues: Report problems or suggest features in the Issues tab

---

**Note:** These scripts are provided as-is. Always review scripts before running them and test in a safe environment first.
