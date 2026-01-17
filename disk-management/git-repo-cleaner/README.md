# Git Repository Cleaner

A pair of Bash scripts to manage disk space by analyzing Git repositories in your work directory. Safely delete synced repositories and restore them later as needed.

**Author:** [@usarral](https://github.com/usarral)

## 📦 Scripts Included

1. **`free_disk_space.sh`** - Analyze and delete synced repositories
2. **`restore_repos.sh`** - Restore previously deleted repositories

## Features

### Free Disk Space Script
- 🔍 Scans all directories in your work folder
- 📊 Checks if each directory is a Git repository
- ✅ Verifies if repositories are fully synced (no uncommitted changes, all pushed)
- 💾 Calculates disk space used by each repository
- 🗑️ Prompts you before deleting any repository
- 📝 Logs deleted repositories in JSON format with remote URLs
- 🎨 Color-coded output for easy reading

### Restore Repositories Script
- 📋 Lists all deleted repositories from JSON log
- 🔄 Restores specific repositories by selection
- ⚡ Batch restore all repositories at once
- 🧹 Automatically removes restored entries from log
- 📍 Clones repositories to their original locations

## Sync Status Checks

The script considers a repository "synced" only if:
- ✅ No uncommitted changes (clean working directory)
- ✅ Has a remote configured
- ✅ Current branch has an upstream set
- ✅ No unpushed commits
- ✅ No unpulled commits
- ✅ Not in detached HEAD state

## Installation

```bash
cd ~/work/scripts/disk-management/git-repo-cleaner
chmod +x free_disk_space.sh
chmod +x restore_repos.sh
```

## Usage

### Freeing Disk Space

```bash
./free_disk_space.sh
```

For each synced repository, the script will:
1. Display the project name
2. Show the disk space it's using
3. Show the remote URL
4. Ask if you want to delete it locally

Example output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ my-project - Git repository found
  Size: 125MB
  Status: ✓ Synced
  Remote: git@github.com:username/my-project.git

  Do you want to delete this project locally?
  (It's fully synced with remote)
  Delete? [y/N]:
```

### Restoring Repositories

```bash
./restore_repos.sh
```

You'll see an interactive menu:
```
Choose an option:
  1 - List all deleted repositories
  2 - Restore specific repository
  3 - Restore all repositories
  4 - Exit
```

**Option 1: List all** - View all deleted repositories with their details

**Option 2: Restore specific** - Select and restore one repository
```
Select Repository to Restore
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] my-old-project
    Remote: git@github.com:username/my-old-project.git
    Size: 125MB
    Deleted: 2024-01-15T14:30:45Z

Enter repository number to restore [1-5]:
```

**Option 3: Restore all** - Clone all deleted repositories back to your work directory

## JSON Log Format

All deleted repositories are logged to `~/work/scripts/deleted_repos.json`:

```json
[
  {
    "timestamp": "2024-01-15T14:30:45Z",
    "project_name": "my-project",
    "remote_url": "git@github.com:username/my-project.git",
    "size_mb": 125,
    "work_dir": "/Users/username/work"
  },
  {
    "timestamp": "2024-01-15T15:22:10Z",
    "project_name": "another-project",
    "remote_url": "https://github.com/username/another-project.git",
    "size_mb": 450,
    "work_dir": "/Users/username/work"
  }
]
```

### JSON Fields

- `timestamp` - ISO 8601 format (UTC) when repository was deleted
- `project_name` - Directory name of the project
- `remote_url` - Git remote URL for cloning
- `size_mb` - Disk space freed in megabytes
- `work_dir` - Original parent directory path

## Manual Recovery

If you prefer to manually restore a repository:

```bash
# View the log
cat ~/work/scripts/deleted_repos.json | jq '.'

# Find the remote URL and clone
cd ~/work
git clone <remote-url>
```

Or use `jq` to query specific projects:

```bash
# Find a specific project
jq '.[] | select(.project_name == "my-project")' deleted_repos.json

# List all project names
jq '.[].project_name' deleted_repos.json

# Get projects deleted after a date
jq '.[] | select(.timestamp > "2024-01-01")' deleted_repos.json
```

## Requirements

- Bash shell
- Git
- `du` command (standard on macOS/Linux)
- `jq` (for restore script) - Install with: `brew install jq`

## Safety Features

- ✅ Only prompts to delete repositories that are fully synced
- ✅ Requires manual confirmation before deletion
- ✅ Logs all deletions in structured JSON format
- ✅ Skips repositories with uncommitted changes
- ✅ Skips repositories with unpushed commits
- ✅ Color-coded warnings for problematic repositories
- ✅ Restore script checks for existing directories before cloning
- ✅ Option to remove or keep log entries after restoration

## Status Indicators

- 🟢 **✓ Synced** - Safe to delete (will prompt)
- 🔴 **✗ Uncommitted changes** - Skipped (has local changes)
- 🔴 **✗ Unpushed commits** - Skipped (not fully backed up)
- 🟡 **⚠ Unpulled commits** - Skipped (remote is ahead)
- 🔴 **✗ No remote** - Skipped (local only)
- 🔴 **✗ No upstream** - Skipped (branch not tracking remote)
- 🟡 **⊘ Not a git repository** - Skipped

## Customization

You can modify these variables at the top of each script:

### free_disk_space.sh
```bash
WORK_DIR="$HOME/work"                                                    # Directory to scan
LOG_FILE="$HOME/work/scripts/disk-management/git-repo-cleaner/deleted_repos.json" # JSON log file
```

### restore_repos.sh
```bash
WORK_DIR="$HOME/work"                                                    # Target directory
LOG_FILE="$HOME/work/scripts/disk-management/git-repo-cleaner/deleted_repos.json" # JSON log file
```

## Example Workflow

### 1. Free up disk space
```bash
./free_disk_space.sh
# Review and delete synced repositories
# Total disk space freed: 1250MB
```

### 2. Later, check what was deleted
```bash
./restore_repos.sh
# Choose option 1 to list all deleted repos
```

### 3. Restore a specific project
```bash
./restore_repos.sh
# Choose option 2
# Enter the number of the project to restore
# The project is cloned back to ~/work/project-name
```

### 4. Restore everything
```bash
./restore_repos.sh
# Choose option 3
# All deleted repositories are restored
```

## Tips

- 📅 Run `free_disk_space.sh` periodically to keep your work directory clean
- 💾 Backup `deleted_repos.json` to cloud storage or version control
- 🔍 Use `jq` to analyze the log file and find patterns
- 🗂️ The restore script removes entries from the log after successful restoration
- ⚠️ If you delete the JSON log file, you'll lose the ability to easily restore projects
- 🔄 You can manually edit the JSON file if needed (be careful with syntax)

## Troubleshooting

### "jq: command not found"
Install jq for the restore script:
```bash
brew install jq
```

### Repository won't delete (shows as not synced)
Check the status message. Common issues:
- Uncommitted changes: `git status` to see what's uncommitted
- Unpushed commits: `git push` to sync with remote
- No upstream: `git push -u origin <branch>`

### Can't restore repository
- Verify you have access to the remote repository
- Check if SSH keys or credentials are set up
- Try cloning manually to see the specific error

### JSON file corrupted
The JSON file should be a valid array. If corrupted:
1. Back up the current file
2. Try to fix with: `cat deleted_repos.json | jq '.' > fixed.json`
3. Or start fresh: `echo "[]" > deleted_repos.json`

## Advanced Usage

### Export log to CSV
```bash
jq -r '.[] | [.timestamp, .project_name, .remote_url, .size_mb] | @csv' deleted_repos.json > deleted_repos.csv
```

### Get total space freed
```bash
jq '[.[].size_mb] | add' deleted_repos.json
```

### Filter by size
```bash
# Projects larger than 100MB
jq '.[] | select(.size_mb > 100)' deleted_repos.json
```

### Restore specific project by name
```bash
# Extract URL
URL=$(jq -r '.[] | select(.project_name == "my-project") | .remote_url' deleted_repos.json)

# Clone it
cd ~/work
git clone "$URL"
```

## License

Free to use and modify as needed.

## Author

**[@usarral](https://github.com/usarral)**

Created to help manage disk space in development environments with many Git repositories.