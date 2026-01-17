# Quick Start Guide - Git Repository Cleaner

**Author:** [@usarral](https://github.com/usarral)

## 🚀 Setup (One-time)

```bash
cd ~/work/scripts/disk-management/git-repo-cleaner
chmod +x free_disk_space.sh restore_repos.sh

# Install jq (needed for restore script)
brew install jq
```

## 📝 Common Commands

### Free Up Disk Space
```bash
cd ~/work/scripts/disk-management/git-repo-cleaner
./free_disk_space.sh
```
- Answer `y` to delete synced repositories
- Answer `n` to keep them

### View Deleted Repositories
```bash
./restore_repos.sh
# Choose option 1
```

### Restore One Repository
```bash
./restore_repos.sh
# Choose option 2
# Enter the number of the repo you want
```

### Restore All Repositories
```bash
./restore_repos.sh
# Choose option 3
```

### View Log File
```bash
cat deleted_repos.json | jq '.'
```

### Search for Specific Project
```bash
jq '.[] | select(.project_name == "my-project")' deleted_repos.json
```

## 📊 Quick Stats

### Total Space Freed
```bash
jq '[.[].size_mb] | add' deleted_repos.json
```

### Count Deleted Repos
```bash
jq 'length' deleted_repos.json
```

### List All Project Names
```bash
jq -r '.[].project_name' deleted_repos.json
```

### Projects Over 100MB
```bash
jq '.[] | select(.size_mb > 100)' deleted_repos.json
```

## 🔄 Typical Workflow

1. **Monthly cleanup:**
   ```bash
   cd ~/work/scripts/disk-management/git-repo-cleaner
   ./free_disk_space.sh
   ```

2. **Need a project back?**
   ```bash
   ./restore_repos.sh  # Option 2
   ```

3. **Check what you've deleted:**
   ```bash
   cat deleted_repos.json | jq -r '.[].project_name'
   ```

## ⚠️ Important Notes

- ✅ Only synced repos are offered for deletion
- ✅ Uncommitted changes = repo is skipped
- ✅ Unpushed commits = repo is skipped
- ✅ All deletions are logged with remote URL
- ✅ Restore script clones from remote

## 🆘 Troubleshooting

**"jq: command not found"**
```bash
brew install jq
```

**Can't restore a repo**
- Check you have access to the remote
- Verify SSH keys are set up
- Try cloning manually to see error

**Wrong remote URL in log**
- Edit `deleted_repos.json` manually (be careful!)
- Or clone with correct URL and remove log entry

## 📁 Files

- `free_disk_space.sh` - Delete synced repos
- `restore_repos.sh` - Restore deleted repos  
- `deleted_repos.json` - Log of deleted repos (JSON format)
- `README.md` - Full documentation
- `WORKFLOW.md` - Visual diagrams

## 💡 Pro Tips

1. Backup `deleted_repos.json` to cloud storage
2. Run cleanup before disk gets full
3. Use `jq` to filter and search the log
4. Keep the log file safe - it's your recovery tool
5. The restore script can overwrite existing dirs (with confirmation)

---

**Author:** [@usarral](https://github.com/usarral)

For detailed documentation, see `README.md`
