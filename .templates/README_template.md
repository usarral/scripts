# Script Name

Brief one-line description of what this script does.

**Author:** [@usarral](https://github.com/usarral)  
**Category:** [Disk Management | Docker | Kubernetes | Utils]

## 📋 Overview

Detailed description of what this script does, the problem it solves, and when you would want to use it.

## ✨ Features

- 🎯 Feature 1 - Description
- 📊 Feature 2 - Description
- ✅ Feature 3 - Description
- 🔄 Feature 4 - Description

## 📦 What's Included

- `script_name.sh` - Main script file
- `README.md` - This documentation
- `config.example.json` - Example configuration (if applicable)

## 🚀 Installation

```bash
cd ~/work/scripts/category/script-name
chmod +x script_name.sh

# Install dependencies if needed
brew install dependency1 dependency2
```

## 📖 Usage

### Basic Usage

```bash
./script_name.sh
```

### With Options

```bash
# Show help
./script_name.sh --help

# Dry run (preview changes without executing)
./script_name.sh --dry-run

# Custom configuration
./script_name.sh --config path/to/config.json
```

## 🎯 Examples

### Example 1: Basic Operation

```bash
./script_name.sh
```

Output:
```
✓ Operation completed successfully
```

### Example 2: With Custom Options

```bash
./script_name.sh --option value
```

### Example 3: Advanced Usage

```bash
VARIABLE=value ./script_name.sh --advanced-option
```

## ⚙️ Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `WORK_DIR` | `$HOME/work` | Working directory path |
| `LOG_FILE` | `~/.local/share/scripts/script.log` | Log file location |
| `DRY_RUN` | `false` | Run without making changes |

### Script Variables

You can modify these variables at the top of the script:

```bash
VARIABLE_NAME="default_value"    # Description of variable
ANOTHER_VAR="value"               # Description of variable
```

## 📋 Requirements

- Bash 4.0 or higher
- Git (for git-related operations)
- `jq` - JSON processor (`brew install jq`)
- Additional requirements specific to this script

## 🔍 How It Works

1. **Step 1**: Description of what happens first
2. **Step 2**: Description of the next step
3. **Step 3**: Description of what comes next
4. **Step 4**: Final step description

## 🎨 Output

The script provides color-coded output:

- 🟢 **Green** (✓) - Success messages
- 🔴 **Red** (✗) - Error messages
- 🟡 **Yellow** (⚠) - Warnings
- 🔵 **Blue** (ℹ) - Information
- 🔷 **Cyan** - Interactive prompts

## 📊 Example Session

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Script Name - Operation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ Checking requirements...
✓ git - OK
✓ jq - OK

ℹ Running main operation...
✓ Step 1 completed
✓ Step 2 completed
✓ Step 3 completed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ℹ Total processed: 10 items
✓ Operation completed successfully!
```

## 🔧 Troubleshooting

### Problem: Error message or issue

**Solution:** Steps to resolve the issue

```bash
# Commands to fix the problem
```

### Problem: Another common issue

**Solution:** How to fix it

### Problem: Permission denied

**Solution:** Make sure the script is executable

```bash
chmod +x script_name.sh
```

## ⚠️ Safety Features

- ✅ Prompts for confirmation before destructive actions
- ✅ Dry-run mode to preview changes
- ✅ Comprehensive logging
- ✅ Error handling with clear messages
- ✅ Rollback capabilities (if applicable)

## 💡 Tips & Best Practices

1. **Tip 1**: Helpful advice for using this script
2. **Tip 2**: Best practice recommendation
3. **Tip 3**: Performance tip or optimization
4. **Tip 4**: When to use or not use this script

## 🔗 Related Scripts

- [Other Script Name](../other-script/) - Related functionality
- [Another Script](../../category/another-script/) - Complementary tool

## 📝 Changelog

### v1.0.0 (YYYY-MM-DD)
- Initial release
- Feature 1 implemented
- Feature 2 implemented

## 🤝 Contributing

Found a bug or have a suggestion? Please open an issue on the main repository!

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for guidelines.

## 📄 License

MIT License - See [LICENSE](../../LICENSE) for details.

## 👤 Author

**[@usarral](https://github.com/usarral)**

Part of the [Scripts Collection](../../README.md)

---

**Note:** Always test scripts in a safe environment before using in production.