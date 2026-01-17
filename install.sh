#!/bin/bash

# Quick Install Script for Scripts Collection
# Author: @usarral
# Repository: https://github.com/usarral/scripts

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}     Scripts Collection - Quick Install${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""
echo -e "Author: ${CYAN}@usarral${NC}"
echo ""

# Check if running from scripts directory
if [[ ! -f "README.md" ]] || [[ ! -d "disk-management" ]]; then
    echo -e "${RED}Error: Please run this script from the scripts directory${NC}"
    echo -e "Expected location: ${YELLOW}~/work/scripts/${NC}"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${YELLOW}Installing from:${NC} $SCRIPT_DIR"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to make scripts executable
make_executable() {
    local category=$1
    local script_dir=$2

    if [[ -d "$SCRIPT_DIR/$category/$script_dir" ]]; then
        echo -e "${BLUE}→${NC} Setting up ${GREEN}$script_dir${NC}..."

        # Make all .sh files executable
        find "$SCRIPT_DIR/$category/$script_dir" -name "*.sh" -type f -exec chmod +x {} \;

        local count=$(find "$SCRIPT_DIR/$category/$script_dir" -name "*.sh" -type f | wc -l)
        echo -e "  ${GREEN}✓${NC} Made $count script(s) executable"
        return 0
    else
        echo -e "  ${YELLOW}⊘${NC} Directory not found, skipping"
        return 1
    fi
}

# Check requirements
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Checking Requirements${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""

# Check Bash
if command_exists bash; then
    BASH_VERSION_NUM=$(bash --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
    echo -e "${GREEN}✓${NC} Bash ${BASH_VERSION_NUM} - OK"
else
    echo -e "${RED}✗${NC} Bash - Not found"
    exit 1
fi

# Check Git
if command_exists git; then
    GIT_VERSION=$(git --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
    echo -e "${GREEN}✓${NC} Git ${GIT_VERSION} - OK"
else
    echo -e "${YELLOW}⚠${NC} Git - Not found (required for git-repo-cleaner)"
fi

# Check jq
if command_exists jq; then
    JQ_VERSION=$(jq --version | grep -oE '[0-9]+\.[0-9]+' | head -n1)
    echo -e "${GREEN}✓${NC} jq ${JQ_VERSION} - OK"
else
    echo -e "${YELLOW}⚠${NC} jq - Not found (required for restore_repos.sh)"
    echo -e "  ${CYAN}Install with:${NC} brew install jq"
    echo ""
    read -p "  Install jq now? [y/N]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command_exists brew; then
            echo -e "  ${BLUE}Installing jq...${NC}"
            brew install jq
            if [ $? -eq 0 ]; then
                echo -e "  ${GREEN}✓${NC} jq installed successfully"
            else
                echo -e "  ${RED}✗${NC} Failed to install jq"
            fi
        else
            echo -e "  ${RED}✗${NC} Homebrew not found. Please install jq manually."
        fi
    fi
fi

echo ""

# Setup scripts
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Setting Up Scripts${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""

installed_count=0

# Disk Management Scripts
if make_executable "disk-management" "git-repo-cleaner"; then
    ((installed_count++))
fi

echo ""

# Summary
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Installation Summary${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""
echo -e "Scripts installed: ${GREEN}$installed_count${NC}"
echo ""

if [[ $installed_count -gt 0 ]]; then
    echo -e "${GREEN}✓ Installation complete!${NC}"
    echo ""
    echo -e "${CYAN}Available Scripts:${NC}"
    echo ""
    echo -e "  ${YELLOW}Git Repository Cleaner${NC}"
    echo -e "    cd disk-management/git-repo-cleaner"
    echo -e "    ./free_disk_space.sh"
    echo ""
    echo -e "${CYAN}Quick Links:${NC}"
    echo -e "  • Main README: ${YELLOW}cat README.md${NC}"
    echo -e "  • Structure: ${YELLOW}cat STRUCTURE.md${NC}"
    echo -e "  • Contributing: ${YELLOW}cat CONTRIBUTING.md${NC}"
else
    echo -e "${YELLOW}No scripts found to install${NC}"
fi

echo ""
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""
echo -e "For more information, visit:"
echo -e "${CYAN}https://github.com/usarral/scripts${NC}"
echo ""
