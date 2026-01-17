# Disk Management Scripts

Scripts for managing disk space, storage, and file systems.

**Author:** [@usarral](https://github.com/usarral)

## 📂 Available Tools

### [Git Repository Cleaner](./git-repo-cleaner)

Analyze and clean up synced Git repositories to free disk space while maintaining the ability to restore them.

**Scripts:**
- `free_disk_space.sh` - Scan and delete synced repositories
- `restore_repos.sh` - Restore deleted repositories from log

**Key Features:**
- ✅ Safety checks (uncommitted changes, unpushed commits)
- 📊 Disk space tracking
- 📝 JSON logging with remote URLs
- 🔄 Easy restoration from remote
- 🎨 Interactive and color-coded

**Use Case:** Perfect for developers with many Git repositories who need to free up space without losing the ability to recover projects.

## 🚀 Quick Start

Navigate to the specific tool directory for detailed instructions:

```bash
cd git-repo-cleaner
cat README.md
```

## 🔮 Coming Soon

- **Duplicate File Finder** - Find and manage duplicate files
- **Large File Analyzer** - Identify space-hogging files
- **Trash Cleaner** - Automated cleanup of old temporary files

## 💡 Tips

- Run disk management scripts regularly (monthly recommended)
- Always backup important data before cleanup operations
- Review logs periodically to track what was deleted
- Keep JSON logs safe for recovery purposes

## 🤝 Contributing

Have a disk management script you find useful? Feel free to suggest it via issues!

---

**Part of the [Scripts Collection](../) by [@usarral](https://github.com/usarral)**