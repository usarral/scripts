# Project Structure

```
scripts/
├── .git/                           # Git repository
├── .gitignore                      # Ignore personal files (logs, configs)
│
├── README.md                       # Main repository documentation
├── LICENSE                         # MIT License
├── CONTRIBUTING.md                 # Contribution guidelines
├── STRUCTURE.md                    # This file
│
├── disk-management/                # 💾 Disk & Storage Management
│   ├── README.md                   # Category overview
│   └── git-repo-cleaner/          # ✅ Clean synced Git repositories
│       ├── README.md              # Full documentation
│       ├── QUICK_START.md         # Quick reference guide
│       ├── WORKFLOW.md            # Visual diagrams
│       ├── free_disk_space.sh     # Main cleanup script
│       ├── restore_repos.sh       # Repository restoration tool
│       └── deleted_repos.example.json  # Example log format
│
├── docker/                         # 🐳 Docker Utilities
│   └── README.md                   # Coming soon
│
├── kubernetes/                     # ☸️ Kubernetes Tools
│   └── README.md                   # Coming soon
│
└── utils/                          # 🔧 General Utilities
    └── README.md                   # Coming soon
```

## 📊 Current Status

### ✅ Available Scripts

| Category | Script | Status | Description |
|----------|--------|--------|-------------|
| Disk Management | git-repo-cleaner | ✅ Ready | Free disk space by cleaning synced Git repos |

### 🚧 Coming Soon

- Docker container cleanup utilities
- Kubernetes cluster management tools
- General utility scripts

## 🗂️ File Types

### Documentation
- `README.md` - Comprehensive guides for each script/category
- `QUICK_START.md` - Quick reference for common operations
- `WORKFLOW.md` - Visual diagrams and workflows
- `CONTRIBUTING.md` - How to contribute to this collection

### Scripts
- `*.sh` - Executable Bash scripts
- All scripts include:
  - Author attribution (@usarral)
  - Usage instructions
  - Safety checks
  - Color-coded output

### Configuration
- `.gitignore` - Excludes personal files (logs, configs, etc.)
- `deleted_repos.json` - Generated log files (gitignored)
- `*.example.json` - Example configuration files (committed)

## 📝 Naming Conventions

### Directories
- `kebab-case` for all directory names
- Category names describe functionality (e.g., `disk-management`)
- Script names are descriptive (e.g., `git-repo-cleaner`)

### Files
- `snake_case.sh` for script files
- `UPPER_CASE.md` for meta documentation
- `README.md` for all directories
- Example files: `name.example.ext`

## 🎯 Design Principles

1. **Safety First** - Always prompt before destructive actions
2. **Clear Documentation** - Every script has comprehensive docs
3. **Reversible** - Provide recovery mechanisms (logs, backups)
4. **Interactive** - User-friendly prompts and color-coded output
5. **Modular** - Each script is self-contained in its directory

## 🔍 Finding Scripts

### By Category
Navigate to the category directory and check its README:
```bash
cd disk-management
cat README.md
```

### By Functionality
Check the main README or category READMEs for script listings.

### By File
All executable scripts end with `.sh` and are in their own directories.

## 📦 Adding New Scripts

When adding a new script:

1. Choose or create appropriate category directory
2. Create dedicated subdirectory for your script
3. Include at minimum:
   - `README.md` with full documentation
   - The script file(s)
   - Example configuration files if needed
4. Update category README
5. Update main README if it's a new category

See `CONTRIBUTING.md` for detailed guidelines.

## 🔗 Navigation

- [Main README](./README.md) - Start here
- [Contributing Guide](./CONTRIBUTING.md) - How to contribute
- [License](./LICENSE) - MIT License

---

**Author:** [@usarral](https://github.com/usarral)  
**Last Updated:** 2024