#!/bin/bash

# Git Repository Cleaner - Free Disk Space Script
# Analyzes work directory for synced git repositories and offers to delete them locally
# while keeping a log of their remote URLs
#
# Author: @usarral
# Repository: https://github.com/usarral/scripts

WORK_DIR="$HOME/work"
LOG_FILE="$HOME/work/scripts/disk-management/git-repo-cleaner/deleted_repos.json"
TOTAL_FREED=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create log file if it doesn't exist (as empty JSON array)
if [[ ! -f "$LOG_FILE" ]]; then
    echo "[]" > "$LOG_FILE"
fi

echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}     Git Repository Disk Space Analyzer${NC}"
echo -e "${BLUE}==================================================${NC}"
echo ""
echo "Scanning: $WORK_DIR"
echo "Log file: $LOG_FILE"
echo ""

# Function to get directory size in MB
get_dir_size() {
    du -sm "$1" 2>/dev/null | cut -f1
}

# Function to check if git repo is synced
is_repo_synced() {
    local repo_path="$1"
    cd "$repo_path" || return 1

    # Check if there are uncommitted changes
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        echo "uncommitted"
        return 1
    fi

    # Check if there's a remote
    if ! git remote -v &>/dev/null || [[ -z $(git remote) ]]; then
        echo "no_remote"
        return 1
    fi

    # Fetch remote to get latest info (quietly)
    git fetch --all --quiet 2>/dev/null

    # Get current branch
    local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    if [[ "$current_branch" == "HEAD" ]]; then
        echo "detached"
        return 1
    fi

    # Check if branch has upstream
    local upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)

    if [[ -z "$upstream" ]]; then
        echo "no_upstream"
        return 1
    fi

    # Check if there are unpushed commits
    local unpushed=$(git log @{u}.. --oneline 2>/dev/null | wc -l)
    local unpulled=$(git log ..@{u} --oneline 2>/dev/null | wc -l)

    if [[ $unpushed -gt 0 ]]; then
        echo "unpushed"
        return 1
    fi

    if [[ $unpulled -gt 0 ]]; then
        echo "unpulled"
        return 1
    fi

    echo "synced"
    return 0
}

# Function to get remote URL
get_remote_url() {
    local repo_path="$1"
    cd "$repo_path" || return 1
    git remote get-url origin 2>/dev/null || git remote -v | head -n1 | awk '{print $2}'
}

# Function to escape JSON strings
escape_json() {
    local string="$1"
    # Escape backslashes, quotes, and control characters
    echo "$string" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed 's/	/\\t/g'
}

# Function to log deleted repository in JSON format
log_deleted_repo() {
    local project_name="$1"
    local remote_url="$2"
    local size="$3"
    local timestamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

    # Escape strings for JSON
    local escaped_name=$(escape_json "$project_name")
    local escaped_url=$(escape_json "$remote_url")

    # Create new entry
    local new_entry=$(cat <<EOF
{
  "timestamp": "$timestamp",
  "project_name": "$escaped_name",
  "remote_url": "$escaped_url",
  "size_mb": $size,
  "work_dir": "$WORK_DIR"
}
EOF
)

    # Read current JSON array, add new entry, and write back
    local current_content=$(cat "$LOG_FILE")

    if [[ "$current_content" == "[]" ]]; then
        # First entry
        echo "[$new_entry]" > "$LOG_FILE"
    else
        # Add to existing array
        # Remove the closing bracket, add comma and new entry, then close bracket
        echo "$current_content" | sed '$ d' > "$LOG_FILE.tmp"
        echo "," >> "$LOG_FILE.tmp"
        echo "$new_entry" >> "$LOG_FILE.tmp"
        echo "]" >> "$LOG_FILE.tmp"
        mv "$LOG_FILE.tmp" "$LOG_FILE"
    fi
}

# Main scanning loop
for project_dir in "$WORK_DIR"/*; do
    # Skip if not a directory
    [[ ! -d "$project_dir" ]] && continue

    project_name=$(basename "$project_dir")

    # Skip the scripts directory itself
    [[ "$project_name" == "scripts" ]] && continue

    # Check if it's a git repository
    if [[ ! -d "$project_dir/.git" ]]; then
        echo -e "${YELLOW}⊘${NC} $project_name - Not a git repository"
        continue
    fi

    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓${NC} $project_name - Git repository found"

    # Get directory size
    size=$(get_dir_size "$project_dir")
    echo -e "  Size: ${YELLOW}${size}MB${NC}"

    # Check sync status
    sync_status=$(is_repo_synced "$project_dir")

    case "$sync_status" in
        "synced")
            echo -e "  Status: ${GREEN}✓ Synced${NC}"
            remote_url=$(get_remote_url "$project_dir")
            echo -e "  Remote: $remote_url"

            # Ask user if they want to delete
            echo -e "\n  ${YELLOW}Do you want to delete this project locally?${NC}"
            echo -e "  (It's fully synced with remote)"
            read -p "  Delete? [y/N]: " -n 1 -r
            echo ""

            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "  ${RED}Deleting...${NC}"

                # Log before deleting
                log_deleted_repo "$project_name" "$remote_url" "$size"

                # Delete the directory
                rm -rf "$project_dir"

                if [[ $? -eq 0 ]]; then
                    echo -e "  ${GREEN}✓ Deleted successfully${NC}"
                    TOTAL_FREED=$((TOTAL_FREED + size))
                else
                    echo -e "  ${RED}✗ Failed to delete${NC}"
                fi
            else
                echo -e "  ${BLUE}Kept${NC}"
            fi
            ;;
        "uncommitted")
            echo -e "  Status: ${RED}✗ Uncommitted changes${NC}"
            ;;
        "no_remote")
            echo -e "  Status: ${RED}✗ No remote configured${NC}"
            ;;
        "no_upstream")
            echo -e "  Status: ${RED}✗ No upstream branch${NC}"
            ;;
        "unpushed")
            echo -e "  Status: ${RED}✗ Unpushed commits${NC}"
            ;;
        "unpulled")
            echo -e "  Status: ${YELLOW}⚠ Unpulled commits${NC}"
            ;;
        "detached")
            echo -e "  Status: ${YELLOW}⚠ Detached HEAD${NC}"
            ;;
        *)
            echo -e "  Status: ${RED}✗ Unknown state${NC}"
            ;;
    esac
done

# Summary
echo -e "\n${BLUE}==================================================${NC}"
echo -e "${BLUE}                    Summary${NC}"
echo -e "${BLUE}==================================================${NC}"
echo -e "Total disk space freed: ${GREEN}${TOTAL_FREED}MB${NC}"
echo -e "Deleted repositories logged to: $LOG_FILE"
echo ""

if [[ $TOTAL_FREED -gt 0 ]]; then
    echo -e "${GREEN}✓ Cleanup complete!${NC}"
else
    echo -e "${YELLOW}No repositories were deleted.${NC}"
fi
