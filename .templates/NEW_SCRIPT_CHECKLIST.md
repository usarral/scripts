# New Script Checklist

When adding a new script to the collection, follow this checklist to ensure consistency and quality.

## 📋 Pre-Development

- [ ] Identify the correct category (disk-management, docker, kubernetes, utils)
- [ ] Choose a descriptive name (use kebab-case for directories, snake_case for scripts)
- [ ] Define the problem the script solves
- [ ] List required dependencies
- [ ] Check if a similar script already exists

## 📁 Directory Structure

- [ ] Create directory: `category/script-name/`
- [ ] Copy `script_template.sh` as starting point
- [ ] Copy `README_template.md` as starting point
- [ ] Add example files if needed (e.g., `config.example.json`)

## 💻 Script Development

### Header
- [ ] Add script name and description
- [ ] Include author: `@usarral`
- [ ] Add repository link: `https://github.com/usarral/scripts`
- [ ] Specify category

### Configuration
- [ ] Define configuration variables with sensible defaults
- [ ] Use environment variables for flexibility
- [ ] Document all configurable options

### Functions
- [ ] Implement utility functions (print_info, print_success, etc.)
- [ ] Add error handling with `error_exit()`
- [ ] Implement logging with `log_message()`
- [ ] Add confirmation prompts for destructive actions

### Main Logic
- [ ] Check requirements at startup
- [ ] Implement dry-run mode for testing
- [ ] Add progress indicators for long operations
- [ ] Provide clear, color-coded output
- [ ] Handle errors gracefully

### Help & Documentation
- [ ] Implement `--help` flag
- [ ] Implement `--version` flag
- [ ] Add usage examples in help text
- [ ] Document all command-line options

## 📝 Documentation

### README.md
- [ ] Add title and brief description
- [ ] Include author attribution
- [ ] List all features
- [ ] Provide installation instructions
- [ ] Add usage examples (at least 3)
- [ ] Document configuration options
- [ ] List requirements
- [ ] Add troubleshooting section
- [ ] Include safety features
- [ ] Add tips and best practices

### QUICK_START.md (optional)
- [ ] Create if the script is complex
- [ ] Include common commands
- [ ] Add quick reference guide
- [ ] Provide typical workflows

### Additional Docs
- [ ] Add diagrams if complex (WORKFLOW.md)
- [ ] Include example configurations
- [ ] Document edge cases

## 🧪 Testing

- [ ] Test syntax: `bash -n script_name.sh`
- [ ] Run with `--help` flag
- [ ] Run with `--version` flag
- [ ] Test dry-run mode (`--dry-run`)
- [ ] Test with default configuration
- [ ] Test with custom configuration
- [ ] Test error conditions
- [ ] Test on clean environment
- [ ] Verify log file creation
- [ ] Test all interactive prompts

## 🔐 Security & Safety

- [ ] No hardcoded passwords or API keys
- [ ] No personal information in code
- [ ] Confirmation prompts for destructive actions
- [ ] Clear warnings for dangerous operations
- [ ] Proper error messages (no exposed sensitive data)
- [ ] Safe defaults (prefer conservative options)
- [ ] Input validation

## 📦 Integration

### Category README
- [ ] Add entry to category README.md
- [ ] Include brief description
- [ ] List key features
- [ ] Add link to script directory

### Main README (if new category)
- [ ] Add category to main README.md
- [ ] Update structure diagram
- [ ] Add to quick start section

### .gitignore
- [ ] Add any generated files to `.gitignore`
- [ ] Ensure no personal data will be committed
- [ ] Test that personal files are ignored

### Install Script
- [ ] Add script to `install.sh` if it needs setup
- [ ] Update installation instructions

## ✅ Code Quality

- [ ] Follow bash best practices
- [ ] Use consistent indentation (2 or 4 spaces)
- [ ] Add comments for complex logic
- [ ] Use meaningful variable names
- [ ] Implement proper error handling
- [ ] Exit with appropriate status codes
- [ ] No linting errors or warnings

## 🎨 User Experience

- [ ] Color-coded output (info, success, warning, error)
- [ ] Clear progress indicators
- [ ] Intuitive prompts with defaults
- [ ] Helpful error messages
- [ ] Professional formatting
- [ ] Consistent with other scripts in collection

## 📋 Final Checks

- [ ] Script is executable: `chmod +x script_name.sh`
- [ ] No syntax errors
- [ ] All paths are configurable (no hardcoded personal paths)
- [ ] Documentation is complete
- [ ] Examples work as documented
- [ ] Log file location is documented
- [ ] Requirements are clearly listed
- [ ] Author attribution is present

## 🚀 Git Commit

Once everything is ready:

```bash
# Add files
git add category/script-name/

# Commit with descriptive message
git commit -m "Add: Script Name for [category]

- Brief description of functionality
- Key features
- Requirements and dependencies"

# Push to repository
git push origin main
```

## 📢 Post-Release

- [ ] Test on fresh clone of repository
- [ ] Monitor for issues/feedback
- [ ] Update documentation if needed
- [ ] Consider adding to showcase/examples

## 🎯 Quality Checklist Summary

**Essential (Must Have):**
- ✅ Working script with no errors
- ✅ Comprehensive README
- ✅ Author attribution
- ✅ Safety prompts
- ✅ Help text

**Recommended (Should Have):**
- ✅ Dry-run mode
- ✅ Logging
- ✅ Color-coded output
- ✅ Examples
- ✅ Troubleshooting guide

**Nice to Have (Could Have):**
- ✅ Quick start guide
- ✅ Workflow diagrams
- ✅ Advanced examples
- ✅ Video demo/GIF

---

**Remember:** Quality over quantity. A well-documented, safe, and tested script is better than a rushed one!

**Author:** [@usarral](https://github.com/usarral)