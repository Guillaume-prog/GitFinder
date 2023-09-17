#!/bin/bash

# Define color escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No color

# Function to check for an existing remote
has_remote_origin() {
    git -C "$1" remote -v | grep -q "origin"
}

# Function to check for uncommitted changes
has_uncommitted_changes() {
    [[ -n $(git -C "$1" status --porcelain) ]]
}

# Function to display usage information
display_usage() {
    echo "Usage: $0 -d <directory> -r <has_remote> -u <has_uncommitted>"
    echo "Options:"
    echo "  -d <directory>         Specify the directory to search (mandatory)"
    echo "  -r <has_remote>        Filter by remote presence: true/false (default: true)"
    echo "  -u <has_uncommitted>   Filter by uncommitted changes: true/false (default: false)"
    echo "  -h                     Display this help message"
}

# Main function to find Git repositories and display information
find_git_repositories() {
    local directory="$1"
    local has_remote_flag="$2"
    local has_uncommitted_flag="$3"

    for d in $(find "$directory" -name ".git"); do
        local repo_dir=$(dirname "$d")

        if [ "$has_remote_flag" == "true" ]; then
            if ! has_remote_origin "$repo_dir"; then
                continue
            fi
        fi

        if [ "$has_uncommitted_flag" == "true" ]; then
            if ! has_uncommitted_changes "$repo_dir"; then
                continue
            fi
        fi

        echo -e "Repository: $repo_dir"

        if [ "$has_remote_flag" == "false" ]; then
          if has_remote_origin "$repo_dir"; then
              echo -e "  - Remote: ${GREEN}Yes ($(git -C "$d" remote get-url origin))${NC}"
          else
              echo -e "  - Remote: ${RED}No${NC}"
          fi
        fi

        if [ "$has_uncommitted_flag" == "false" ]; then
          if has_uncommitted_changes "$repo_dir"; then
              echo -e "  - Uncommitted changes: ${RED}Yes${NC}"
          else
              echo -e "  - Uncommitted changes: ${GREEN}No${NC}"
          fi
        fi

        echo
    done
}

# Parse command-line options
while getopts ":d:r:u:h" opt; do
    case $opt in
    d) directory="$OPTARG" ;;
    r) has_remote_flag="$OPTARG" ;;
    u) has_uncommitted_flag="$OPTARG" ;;
    h) display_usage; exit 0 ;;
    *) echo "Invalid option" ;;
    esac
done

# Check if mandatory -d option is provided
if [ -z "$directory" ]; then
    echo "Error: -d <directory> is a required option."
    display_usage
    exit 1
fi

# Set default values if not provided
has_remote_flag="${has_remote_flag:-false}"
has_uncommitted_flag="${has_uncommitted_flag:-false}"

# Run the script
find_git_repositories "$directory" "$has_remote_flag" "$has_uncommitted_flag"
