#!/bin/bash

# Script Name - Brief Description
# Detailed description of what this script does
#
# Author: @usarral
# Repository: https://github.com/usarral/scripts
# Category: [disk-management|docker|kubernetes|utils]

set -e  # Exit on error
set -u  # Exit on undefined variable

# Configuration Variables
WORK_DIR="${WORK_DIR:-$HOME/work}"
LOG_FILE="${LOG_FILE:-$HOME/.local/share/scripts/script.log}"
DRY_RUN="${DRY_RUN:-false}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Script metadata
SCRIPT_NAME="$(basename "$0")"
SCRIPT_VERSION="1.0.0"

# ============================================================================
# Utility Functions
# ============================================================================

# Print colored message
print_info() {
    echo -e "${BLUE}ℹ${NC} $*"
}

print_success() {
    echo -e "${GREEN}✓${NC} $*"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $*"
}

print_error() {
    echo -e "${RED}✗${NC} $*" >&2
}

print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$*${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Confirm action with user
confirm() {
    local prompt="${1:-Continue?}"
    local default="${2:-N}"

    if [[ "$default" == "Y" ]]; then
        read -p "$(echo -e ${YELLOW}${prompt}${NC}) [Y/n]: " -n 1 -r
    else
        read -p "$(echo -e ${YELLOW}${prompt}${NC}) [y/N]: " -n 1 -r
    fi
    echo ""

    if [[ "$default" == "Y" ]]; then
        [[ ! $REPLY =~ ^[Nn]$ ]]
    else
        [[ $REPLY =~ ^[Yy]$ ]]
    fi
}

# Log message to file
log_message() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

    # Create log directory if it doesn't exist
    mkdir -p "$(dirname "$LOG_FILE")"

    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

# Error handler
error_exit() {
    local message="$1"
    local exit_code="${2:-1}"

    print_error "$message"
    log_message "ERROR" "$message"
    exit "$exit_code"
}

# ============================================================================
# Main Functions
# ============================================================================

# Show usage information
show_usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS]

Brief description of what this script does.

OPTIONS:
    -h, --help          Show this help message
    -v, --version       Show version information
    -d, --dry-run       Run without making changes
    --work-dir DIR      Set work directory (default: $WORK_DIR)
    --log-file FILE     Set log file (default: $LOG_FILE)

EXAMPLES:
    # Basic usage
    $SCRIPT_NAME

    # Dry run
    $SCRIPT_NAME --dry-run

    # Custom work directory
    $SCRIPT_NAME --work-dir /path/to/directory

ENVIRONMENT VARIABLES:
    WORK_DIR            Work directory path
    LOG_FILE            Log file path
    DRY_RUN             Set to 'true' for dry run

AUTHOR:
    @usarral - https://github.com/usarral

EOF
}

# Show version information
show_version() {
    echo "$SCRIPT_NAME version $SCRIPT_VERSION"
    echo "Author: @usarral"
}

# Check requirements
check_requirements() {
    print_info "Checking requirements..."

    local missing_requirements=false

    # Add your required commands here
    local required_commands=("git" "jq")

    for cmd in "${required_commands[@]}"; do
        if command_exists "$cmd"; then
            print_success "$cmd - OK"
        else
            print_error "$cmd - Not found"
            missing_requirements=true
        fi
    done

    if [[ "$missing_requirements" == true ]]; then
        error_exit "Missing required dependencies. Please install them and try again."
    fi

    echo ""
}

# Main script logic
main() {
    print_header "$SCRIPT_NAME - Script Description"

    log_message "INFO" "Script started"

    # Check requirements
    check_requirements

    # Your main script logic here
    print_info "Running main script logic..."

    if [[ "$DRY_RUN" == "true" ]]; then
        print_warning "DRY RUN MODE - No changes will be made"
    fi

    # Example: Confirm action
    if confirm "Do you want to proceed?"; then
        print_success "Proceeding..."

        # Add your logic here

        print_success "Operation completed successfully!"
        log_message "INFO" "Operation completed successfully"
    else
        print_warning "Operation cancelled by user"
        log_message "INFO" "Operation cancelled by user"
        exit 0
    fi

    # Summary
    print_header "Summary"
    print_info "Log file: $LOG_FILE"
}

# ============================================================================
# Parse Arguments
# ============================================================================

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            --work-dir)
                WORK_DIR="$2"
                shift 2
                ;;
            --log-file)
                LOG_FILE="$2"
                shift 2
                ;;
            *)
                print_error "Unknown option: $1"
                echo ""
                show_usage
                exit 1
                ;;
        esac
    done
}

# ============================================================================
# Entry Point
# ============================================================================

# Parse command line arguments
parse_arguments "$@"

# Run main function
main

# Exit successfully
exit 0
