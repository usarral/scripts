# Contributing to Scripts Collection

Thank you for your interest in contributing to this scripts collection!

## 👤 About This Repository

This is a personal collection of scripts created and maintained by [@usarral](https://github.com/usarral). While this is primarily for my own use, I welcome feedback, suggestions, and contributions from the community.

## 🤝 How to Contribute

### 1. Reporting Issues

If you find a bug or have a suggestion:
- Open an issue describing the problem or idea
- Include relevant details (OS, shell version, error messages)
- For bugs, provide steps to reproduce

### 2. Suggesting New Scripts

Have an idea for a useful script?
- Open an issue with the `enhancement` label
- Describe the use case and what the script should do
- Explain why it would be useful

### 3. Improving Documentation

Documentation improvements are always welcome!
- Fix typos or unclear explanations
- Add examples or use cases
- Improve formatting or organization

### 4. Code Contributions

If you'd like to contribute code:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-script`)
3. **Follow the script guidelines** (see below)
4. **Test thoroughly** on your local environment
5. **Commit with clear messages** (`git commit -m 'Add: Docker cleanup script'`)
6. **Push to your fork** (`git push origin feature/amazing-script`)
7. **Open a Pull Request**

## 📝 Script Guidelines

All scripts in this collection should follow these principles:

### Safety First
- ✅ Always prompt before destructive actions
- ✅ Provide dry-run or preview options when possible
- ✅ Include clear warnings for dangerous operations
- ✅ Never hardcode personal paths or credentials

### Code Quality
- ✅ Use clear, descriptive variable names
- ✅ Add comments for complex logic
- ✅ Handle errors gracefully
- ✅ Include usage/help messages (`--help`)
- ✅ Exit with appropriate status codes

### User Experience
- ✅ Use color-coded output (info, success, warning, error)
- ✅ Provide progress indicators for long operations
- ✅ Make interactive prompts clear and concise
- ✅ Include examples in help text

### Documentation
- ✅ Include a comprehensive README
- ✅ Document all configurable variables
- ✅ Provide usage examples
- ✅ List requirements and dependencies
- ✅ Add troubleshooting section

### Script Structure
```bash
#!/bin/bash

# Script Name - Brief Description
# Detailed description of what the script does
#
# Author: @usarral
# Repository: https://github.com/usarral/scripts

# Configuration variables
VARIABLE_NAME="default_value"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
function_name() {
    # Function description
    local param=$1
    # Implementation
}

# Main script logic
main() {
    # Script body
}

# Run main function
main "$@"
```

## 📂 Directory Structure

When adding a new script:

1. **Choose the right category:**
   - `disk-management/` - Disk space and storage
   - `docker/` - Docker utilities
   - `kubernetes/` - Kubernetes tools
   - `utils/` - General utilities

2. **Create a dedicated directory:**
   ```
   category/
   └── script-name/
       ├── README.md
       ├── script.sh
       ├── QUICK_START.md (optional)
       └── example files
   ```

3. **Update category README** to list your script

## ✅ Pull Request Checklist

Before submitting a PR, ensure:

- [ ] Script follows the guidelines above
- [ ] Code is well-commented
- [ ] README is comprehensive
- [ ] Script is executable (`chmod +x`)
- [ ] No syntax errors (`bash -n script.sh`)
- [ ] Tested on your local environment
- [ ] No personal/sensitive information included
- [ ] Author attribution included in script header

## 🔍 Code Review

All contributions will be reviewed for:
- Code quality and safety
- Documentation completeness
- Consistency with existing scripts
- Usefulness and practicality

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 💬 Questions?

Feel free to:
- Open an issue for questions
- Start a discussion
- Reach out to [@usarral](https://github.com/usarral)

## 🙏 Thank You!

Your contributions help make this collection more useful for everyone!

---

**Remember:** These scripts are meant to be practical, safe, and well-documented. Quality over quantity!