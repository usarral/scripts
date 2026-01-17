#!/bin/bash

# Git Repository Cleaner - Restore Repositories Script
# Reclones deleted repositories from the JSON log file
#
# Author: @usarral
# Repository: https://github.com/usarral/scripts

WORK_DIR="$HOME/work"
LOG_FILE="$HOME/work/scripts/disk-management/git-repo-cleaner/deleted_repos.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if log file exists
if [[ ! -f "$LOG_FILE" ]]; then
    echo -e "${RED}Error: Log file not found at $LOG_FILE${NC}"
    exit 1
fi

# Check if jq is available for JSON parsing
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: 'jq' is required but not installed.${NC}"
    echo -e "Install it with: ${YELLOW}brew install jq${NC}"
    exit 1
fi

echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}     Repository Restoration Tool${NC}"
echo -e "${BLUE}==================================================${NC}"
echo ""

# Read and parse JSON log
entries_count=$(jq length "$LOG_FILE")

if [[ $entries_count -eq 0 ]]; then
    echo -e "${YELLOW}No deleted repositories found in log.${NC}"
    exit 0
fi

echo -e "Found ${GREEN}$entries_count${NC} deleted repository/repositories in log."
echo ""

# Function to display repository info
display_repo() {
    local index=$1
    local name=$(jq -r ".[$index].project_name" "$LOG_FILE")
    local url=$(jq -r ".[$index].remote_url" "$LOG_FILE")
    local size=$(jq -r ".[$index].size_mb" "$LOG_FILE")
    local timestamp=$(jq -r ".[$index].timestamp" "$LOG_FILE")

    echo -e "${CYAN}[$((index + 1))]${NC} ${GREEN}$name${NC}"
    echo -e "    Remote: $url"
    echo -e "    Size: ${YELLOW}${size}MB${NC}"
    echo -e "    Deleted: $timestamp"
}

# Function to clone repository
clone_repo() {
    local index=$1
    local name=$(jq -r ".[$index].project_name" "$LOG_FILE")
    local url=$(jq -r ".[$index].remote_url" "$LOG_FILE")
    local target_dir="$WORK_DIR/$name"

    # Check if directory already exists
    if [[ -d "$target_dir" ]]; then
        echo -e "  ${YELLOW}⚠ Directory already exists: $name${NC}"
        read -p "  Overwrite? [y/N]: " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "  ${BLUE}Skipped${NC}"
            return 1
        fi
        echo -e "  ${RED}Removing existing directory...${NC}"
        rm -rf "$target_dir"
    fi

    echo -e "  ${BLUE}Cloning from $url...${NC}"

    if git clone "$url" "$target_dir" 2>&1 | grep -v "^Cloning into"; then
        echo -e "  ${GREEN}✓ Successfully cloned${NC}"
        return 0
    else
        echo -e "  ${RED}✗ Failed to clone${NC}"
        return 1
    fi
}

# Function to remove entry from log
remove_from_log() {
    local index=$1
    jq "del(.[$index])" "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
}

# Interactive mode
echo -e "${YELLOW}Choose an option:${NC}"
echo -e "  ${CYAN}1${NC} - List all deleted repositories"
echo -e "  ${CYAN}2${NC} - Restore specific repository"
echo -e "  ${CYAN}3${NC} - Restore all repositories"
echo -e "  ${CYAN}4${NC} - Exit"
echo ""
read -p "Enter choice [1-4]: " choice

case $choice in
    1)
        # List all repositories
        echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}Deleted Repositories${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""

        for ((i=0; i<entries_count; i++)); do
            display_repo $i
            echo ""
        done

        echo -e "${GREEN}Total: $entries_count repositories${NC}"
        ;;

    2)
        # Restore specific repository
        echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}Select Repository to Restore${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""

        for ((i=0; i<entries_count; i++)); do
            display_repo $i
            echo ""
        done

        read -p "Enter repository number to restore [1-$entries_count]: " repo_num

        if [[ ! "$repo_num" =~ ^[0-9]+$ ]] || [[ $repo_num -lt 1 ]] || [[ $repo_num -gt $entries_count ]]; then
            echo -e "${RED}Invalid selection.${NC}"
            exit 1
        fi

        index=$((repo_num - 1))
        name=$(jq -r ".[$index].project_name" "$LOG_FILE")

        echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}Restoring: $name${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

        if clone_repo $index; then
            read -p "Remove from log file? [Y/n]: " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                remove_from_log $index
                echo -e "  ${GREEN}✓ Removed from log${NC}"
            fi
        fi
        ;;

    3)
        # Restore all repositories
        echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${YELLOW}⚠ Warning: This will restore all $entries_count repositories${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""

        read -p "Continue? [y/N]: " -n 1 -r
        echo ""

        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Cancelled.${NC}"
            exit 0
        fi

        success_count=0
        failed_count=0

        for ((i=entries_count-1; i>=0; i--)); do
            name=$(jq -r ".[$i].project_name" "$LOG_FILE")
            echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${GREEN}[$((entries_count - i))/$entries_count] Restoring: $name${NC}"
            echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

            if clone_repo $i; then
                remove_from_log $i
                success_count=$((success_count + 1))
            else
                failed_count=$((failed_count + 1))
            fi
        done

        echo -e "\n${BLUE}==================================================${NC}"
        echo -e "${BLUE}                    Summary${NC}"
        echo -e "${BLUE}==================================================${NC}"
        echo -e "Successfully restored: ${GREEN}$success_count${NC}"
        echo -e "Failed: ${RED}$failed_count${NC}"

        if [[ $success_count -gt 0 ]]; then
            echo -e "\n${GREEN}✓ Restoration complete!${NC}"
        fi
        ;;

    4)
        echo -e "${YELLOW}Exiting...${NC}"
        exit 0
        ;;

    *)
        echo -e "${RED}Invalid choice.${NC}"
        exit 1
        ;;
esac
