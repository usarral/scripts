# Workflow Diagram

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        ~/work Directory                         │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐           │
│  │Project 1│  │Project 2│  │Project 3│  │Project N│  ...       │
│  │  (.git) │  │  (.git) │  │  (.git) │  │  (.git) │           │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ Scans
                              ▼
              ┌───────────────────────────────┐
              │   free_disk_space.sh          │
              │                               │
              │  • Checks Git status          │
              │  • Verifies sync state        │
              │  • Calculates size            │
              │  • Prompts user               │
              └───────────────┬───────────────┘
                              │
                ┌─────────────┴─────────────┐
                │                           │
           Keeps │                          │ Deletes
                │                           │
                ▼                           ▼
        ┌───────────────┐         ┌─────────────────┐
        │  Repository   │         │    Logs to      │
        │  stays local  │         │ deleted_repos   │
        └───────────────┘         │    .json        │
                                  └────────┬─────────┘
                                           │
                                           │ Stores
                                           ▼
                              ┌────────────────────────┐
                              │  {                     │
                              │   "project_name": "x"  │
                              │   "remote_url": "..."  │
                              │   "size_mb": 125       │
                              │   "timestamp": "..."   │
                              │  }                     │
                              └────────┬───────────────┘
                                       │
                              Later... │ Reads
                                       ▼
                              ┌─────────────────────┐
                              │  restore_repos.sh   │
                              │                     │
                              │  • Lists deleted    │
                              │  • User selects     │
                              │  • Clones from URL  │
                              └──────────┬──────────┘
                                         │
                                         │ Clones
                                         ▼
                              ┌─────────────────────┐
                              │  Repository         │
                              │  restored to        │
                              │  ~/work/project     │
                              └─────────────────────┘
```

## Decision Flow - free_disk_space.sh

```
                    Start Scan
                        │
                        ▼
              ┌─────────────────────┐
              │ For each directory  │
              │   in ~/work/        │
              └──────────┬──────────┘
                         │
                         ▼
                 ┌───────────────┐
           ┌─────│ Is directory? │─────┐
           │     └───────────────┘     │
          NO                          YES
           │                            │
           ▼                            ▼
         Skip              ┌─────────────────────┐
                     ┌─────│ Has .git directory? │─────┐
                     │     └─────────────────────┘     │
                    NO                               YES
                     │                                 │
                     ▼                                 ▼
            ⊘ Not a Git repo               ┌──────────────────┐
                                            │ Check Git Status │
                                            └────────┬─────────┘
                                                     │
                          ┌──────────────────────────┼──────────────────────────┐
                          │                          │                          │
                          ▼                          ▼                          ▼
                  Uncommitted?              No Remote?                   Unpushed?
                          │                          │                          │
                         YES                        YES                        YES
                          │                          │                          │
                          ▼                          ▼                          ▼
                  ✗ Skip (unsafe)           ✗ Skip (no backup)          ✗ Skip (unsafe)
                          
                                                     │
                                                    NO (all checks pass)
                                                     │
                                                     ▼
                                          ┌──────────────────┐
                                          │ ✓ SYNCED         │
                                          │                  │
                                          │ Show details:    │
                                          │ • Size           │
                                          │ • Remote URL     │
                                          └────────┬─────────┘
                                                   │
                                                   ▼
                                          ┌──────────────────┐
                                          │ Ask user:        │
                                          │ Delete? [y/N]    │
                                          └────────┬─────────┘
                                                   │
                                       ┌───────────┴───────────┐
                                       │                       │
                                      YES                     NO
                                       │                       │
                                       ▼                       ▼
                            ┌──────────────────┐     ┌──────────────┐
                            │ 1. Log to JSON   │     │ Keep locally │
                            │ 2. Delete dir    │     └──────────────┘
                            │ 3. Free space++  │
                            └──────────────────┘
```

## Sync Status Checks

```
┌────────────────────────────────────────────────────────────┐
│                  Repository Sync Checks                    │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ✅ Working Directory Clean                               │
│     git status --porcelain (empty output)                 │
│                                                            │
│  ✅ Remote Configured                                     │
│     git remote -v (has origin)                            │
│                                                            │
│  ✅ Branch Tracking Upstream                              │
│     git rev-parse @{u} (succeeds)                         │
│                                                            │
│  ✅ No Unpushed Commits                                   │
│     git log @{u}.. --oneline (count = 0)                  │
│                                                            │
│  ✅ No Unpulled Commits                                   │
│     git log ..@{u} --oneline (count = 0)                  │
│                                                            │
│  ✅ Not Detached HEAD                                     │
│     git rev-parse --abbrev-ref HEAD (not "HEAD")          │
│                                                            │
└────────────────────────────────────────────────────────────┘
         │
         │ ALL PASS
         ▼
    ✓ SYNCED - Safe to delete
```

## Restore Process

```
                User runs restore_repos.sh
                           │
                           ▼
                ┌──────────────────┐
                │  Read JSON log   │
                │ deleted_repos    │
                │     .json        │
                └────────┬─────────┘
                         │
                         ▼
                ┌──────────────────┐
                │  Show Menu:      │
                │  1. List all     │
                │  2. Restore one  │
                │  3. Restore all  │
                │  4. Exit         │
                └────────┬─────────┘
                         │
            ┌────────────┼────────────┐
            │            │            │
            ▼            ▼            ▼
    ┌─────────────┐ ┌─────────┐ ┌──────────┐
    │ List repos  │ │ Select  │ │ Clone    │
    │ with jq     │ │ repo #  │ │ all from │
    └─────────────┘ └────┬────┘ │ log      │
                         │      └────┬─────┘
                         └───────────┤
                                     ▼
                          ┌──────────────────┐
                          │ For each repo:   │
                          │                  │
                          │ 1. Check if dir  │
                          │    exists        │
                          │                  │
                          │ 2. git clone URL │
                          │    to ~/work/    │
                          │                  │
                          │ 3. Remove from   │
                          │    JSON log      │
                          └──────────────────┘
```

## JSON Log Structure

```
deleted_repos.json
    │
    ├── Entry 1
    │   ├── timestamp ───────── "2024-01-15T14:30:45Z"
    │   ├── project_name ────── "my-project"
    │   ├── remote_url ──────── "git@github.com:user/repo.git"
    │   ├── size_mb ─────────── 125
    │   └── work_dir ────────── "/Users/username/work"
    │
    ├── Entry 2
    │   ├── timestamp ───────── "2024-01-15T15:22:10Z"
    │   ├── project_name ────── "another-project"
    │   ├── remote_url ──────── "https://github.com/user/repo.git"
    │   ├── size_mb ─────────── 450
    │   └── work_dir ────────── "/Users/username/work"
    │
    └── Entry N...
```

## Data Flow

```
┌──────────────┐
│ Local Repo   │
│ (Git synced) │
└──────┬───────┘
       │
       │ Delete
       ▼
┌────────────────────────────────────┐
│  deleted_repos.json                │
│  [                                 │
│    {                               │
│      "project_name": "repo",       │
│      "remote_url": "git@...",      │
│      ...                           │
│    }                               │
│  ]                                 │
└──────┬─────────────────────────────┘
       │
       │ Clone from URL
       ▼
┌──────────────┐
│ Restored     │
│ Local Repo   │
└──────────────┘
```

## Safety Net

```
                    Deletion Request
                          │
                          ▼
              ┌───────────────────────┐
              │   Multiple Checks     │
              ├───────────────────────┤
              │ • Git status          │
              │ • Remote exists       │
              │ • All pushed          │
              │ • All committed       │
              │ • User confirmation   │
              └───────────┬───────────┘
                          │
                   All checks pass
                          │
                          ▼
              ┌───────────────────────┐
              │   Log to JSON         │
              │   (Remote URL saved)  │
              └───────────┬───────────┘
                          │
                          ▼
              ┌───────────────────────┐
              │   Delete Directory    │
              └───────────┬───────────┘
                          │
                          ▼
              ┌───────────────────────┐
              │   Repository can be   │
              │   restored anytime    │
              │   using JSON log      │
              └───────────────────────┘
```

## Typical User Journey

```
Week 1: Disk getting full
   │
   ├─► Run: ./free_disk_space.sh
   │      Delete 5 old projects
   │      Free: 2.5 GB
   │
Week 3: Need old project
   │
   ├─► Run: ./restore_repos.sh
   │      Choose option 2
   │      Select project #3
   │      Project cloned back
   │
Week 6: Clean up again
   │
   └─► Run: ./free_disk_space.sh
          Delete 3 more projects
          Free: 1.8 GB
```

## Color Coding in Output

```
free_disk_space.sh Output:

🟢 GREEN   = ✓ Synced (safe to delete)
🔴 RED     = ✗ Problem (skip - unsafe)
🟡 YELLOW  = ⚠ Warning or prompt
🔵 BLUE    = ℹ Info/headers
⚪ WHITE   = 📊 Data/stats

restore_repos.sh Output:

🟢 GREEN   = ✓ Success
🔴 RED     = ✗ Error
🟡 YELLOW  = ⚠ Warning/confirmation
🔵 BLUE    = ℹ Info/headers
🔷 CYAN    = 📋 Menu options/numbers
```

## Best Practices

```
┌─────────────────────────────────────────────────────────┐
│                    Best Practices                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. Run free_disk_space.sh monthly                     │
│                                                         │
│  2. Backup deleted_repos.json to cloud                 │
│                                                         │
│  3. Review repos before deleting                       │
│                                                         │
│  4. Keep log file safe                                 │
│                                                         │
│  5. Use restore_repos.sh when needed                   │
│                                                         │
│  6. Verify remote access before restoring              │
│                                                         │
└─────────────────────────────────────────────────────────┘
```
