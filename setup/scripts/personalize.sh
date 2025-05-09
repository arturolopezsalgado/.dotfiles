#!/usr/bin/env zsh
#
# Script to personalize configuration files with user information
# This script should be run before the main install process to configure personal settings
# and create necessary directory structure based on user preferences.
#

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Source utility scripts if available
PERSONALIZE_SCRIPT_DIR=$(dirname "$0")
if [[ -f "$PERSONALIZE_SCRIPT_DIR/../utils/colors.sh" ]]; then
  source "$PERSONALIZE_SCRIPT_DIR/../utils/colors.sh"
else
  # Simple fallback for colors if not available
  header() { echo "\n----- $1 -----\n"; }
  step() { echo "→ $1"; }
  success() { echo "✓ $1"; }
  error() { echo "✗ $1"; }
  info() { echo "ℹ $1"; }
  warning() { echo "⚠ $1"; }
  note() { echo "Note: $1"; }
fi

# Repository root
REPO_ROOT=$(cd "$PERSONALIZE_SCRIPT_DIR/../.." && pwd)

# Default paths for git repository locations
DEFAULT_DEV_DIR="$HOME/dev"
DEFAULT_DOCUMENTS_DIR="$HOME/Documents"
DEFAULT_PERSONAL_SUFFIX="Personal"
DEFAULT_WORK_SUFFIX="Work"

header "Git Configuration Personalization"
info "This script will personalize your git configuration files with your information."
info "Your personal information will not be committed to the repository."

# Check if personalized files already exist
check_existing_files() {
  local personal_exists=0
  local work_exists=0

  if [[ -f "$REPO_ROOT/home/.config/git/config-personal" ]]; then
    personal_exists=1
  fi

  if [[ -f "$REPO_ROOT/home/.config/git/config-work" ]]; then
    work_exists=1
  fi

  # If any files exist, and wants to overwrite
  if [[ $personal_exists -eq 1 || $work_exists -eq 1 ]]; then
    warning "Personalized configuration files already exist:"
    [[ $personal_exists -eq 1 ]] && echo "  - Personal Git config"
    [[ $work_exists -eq 1 ]] && echo "  - Work Git config"
    echo ""
    echo -n "Do you want to overwrite these files? [y/n] "
    read -r overwrite_choice
    if [[ "$overwrite_choice" != "y" && "$overwrite_choice" != "Y" ]]; then
      note "Keeping existing git files."
      return 1
    fi
  fi

  return 0
}

# Setup development directories based on user preferences
setup_project_directories() {
  header "Project Directories Setup"
  info "Let's set up your project directories for personal and work repositories."

  # Ask if user wants to use dev directory
  echo ""
  echo -n "Do you want to create a dedicated 'dev' directory in your home folder? (Recommended) [y/n] "
  read -r create_dev_dir

  if [[ "$create_dev_dir" == "y" || "$create_dev_dir" == "Y" ]]; then
    # User wants dev directory
    base_dir="$DEFAULT_DEV_DIR"
    step "Will use ~/dev as your base projects directory"
  else
    # User prefers Documents or other directory
    echo ""
    echo "Common alternatives are 'Documents', 'Projects', or 'code'"
    echo -n "Enter the name of the directory to use in your home folder (default: Documents), or press Enter to use the default: "
    read -r alt_dir_name

    if [[ -z "$alt_dir_name" ]]; then
      alt_dir_name="Documents"
    fi

    base_dir="$HOME/$alt_dir_name"
    step "Will use ~/$alt_dir_name as your base projects directory"
  fi

  # Ask for personal projects subdirectory
  echo ""
  echo -n "Enter name for your personal projects subfolder (default: Personal), or press Enter to use the default: "
  read -r personal_dir
  if [[ -z "$personal_dir" ]]; then
    personal_dir="$DEFAULT_PERSONAL_SUFFIX"
  fi
  personal_projects_path="$base_dir/$personal_dir"

  # Ask for work projects subdirectory
  echo ""
  echo -n "Enter name for your work projects subfolder (default: Work), or press Enter to use the default: "
  read -r work_dir
  if [[ -z "$work_dir" ]]; then
    work_dir="$DEFAULT_WORK_SUFFIX"
  fi
  work_projects_path="$base_dir/$work_dir"

  # Create the directories if they don't exist
  step "Creating directory structure (if needed)..."

  # Create base directory if it doesn't exist
  if [[ ! -d "$base_dir" ]]; then
    mkdir -p "$base_dir"
    success "Created base directory: $base_dir"
  else
    info "Base directory already exists: $base_dir"
  fi

  # Create personal projects directory if it doesn't exist
  if [[ ! -d "$personal_projects_path" ]]; then
    mkdir -p "$personal_projects_path"
    success "Created personal projects directory: $personal_projects_path"
  else
    info "Personal projects directory already exists: $personal_projects_path"
  fi

  # Create work projects directory if it doesn't exist
  if [[ ! -d "$work_projects_path" ]]; then
    mkdir -p "$work_projects_path"
    success "Created work projects directory: $work_projects_path"
  else
    info "Work projects directory already exists: $work_projects_path"
  fi

  # Store paths for gitconfig template
  export PERSONAL_PROJECTS_PATH="$personal_projects_path"
  export WORK_PROJECTS_PATH="$work_projects_path"

  success "Directory structure setup complete"
}

# Create .gitconfig from template
create_gitconfig() {
  step "Creating .gitconfig from template..."

  # Check if template exists
  if [[ ! -f "$REPO_ROOT/home/.gitconfig.template" ]]; then
    error "Git config template not found at $REPO_ROOT/home/.gitconfig.template"
    return 1
  fi

  # Create gitconfig from template
  cp "$REPO_ROOT/home/.gitconfig.template" "$REPO_ROOT/home/.gitconfig"

  # Normalize paths for gitconfig (convert /Users/username to ~)
  local personal_rel_path=${PERSONAL_PROJECTS_PATH/$HOME/\~}
  local work_rel_path=${WORK_PROJECTS_PATH/$HOME/\~}

  # Replace placeholders
  sed -i '' "s|__PERSONAL_PROJECTS_PATH__|$personal_rel_path|g" "$REPO_ROOT/home/.gitconfig"
  sed -i '' "s|__WORK_PROJECTS_PATH__|$work_rel_path|g" "$REPO_ROOT/home/.gitconfig"

  success "Created personalized .gitconfig"
}

# Prompt for user information and create personalized files
create_personalized_files() {
  # Prompt for personal information
  echo ""
  step "Please enter your git personal information:"
  echo ""
  echo -n "Personal Name: "
  read -r personal_name
  echo -n "Personal Email: "
  read -r personal_email
  echo -n "Personal GitHub Username: "
  read -r personal_github
  echo ""
  echo -n "Work Name: "
  read -r work_name
  echo -n "Work Email: "
  read -r work_email
  echo -n "Work GitHub Username: "
  read -r work_github

  # Process Git configuration templates
  step "Personalizing Git configuration..."

  # Export personal and work information for other scripts
  export GIT_PERSONAL_NAME="$personal_name"
  export GIT_PERSONAL_EMAIL="$personal_email"
  export GIT_PERSONAL_GITHUB="$personal_github"
  export GIT_WORK_NAME="$work_name"
  export GIT_WORK_EMAIL="$work_email"
  export GIT_WORK_GITHUB="$work_github"

  # Personal Git config
  if [[ -f "$REPO_ROOT/home/.config/git/config-personal.template" ]]; then
    # Create the output file from template
    cp "$REPO_ROOT/home/.config/git/config-personal.template" "$REPO_ROOT/home/.config/git/config-personal"

    # Replace all placeholders
    sed -i '' "s|__PERSONAL_NAME__|$personal_name|g" "$REPO_ROOT/home/.config/git/config-personal"
    sed -i '' "s|__PERSONAL_EMAIL__|$personal_email|g" "$REPO_ROOT/home/.config/git/config-personal"
    sed -i '' "s|__PERSONAL_GITHUB__|$personal_github|g" "$REPO_ROOT/home/.config/git/config-personal"
    success "Personal Git configuration personalized"
  else
    warning "Personal Git config template not found at $REPO_ROOT/home/.config/git/config-personal.template"
  fi

  # Work Git config
  if [[ -f "$REPO_ROOT/home/.config/git/config-work.template" ]]; then
    # Create the output file from template
    cp "$REPO_ROOT/home/.config/git/config-work.template" "$REPO_ROOT/home/.config/git/config-work"

    # Replace all placeholders
    sed -i '' "s|__WORK_NAME__|$work_name|g" "$REPO_ROOT/home/.config/git/config-work"
    sed -i '' "s|__WORK_EMAIL__|$work_email|g" "$REPO_ROOT/home/.config/git/config-work"
    sed -i '' "s|__WORK_GITHUB__|$work_github|g" "$REPO_ROOT/home/.config/git/config-work"
    success "Work Git configuration personalized"
  else
    warning "Work Git config template not found at $REPO_ROOT/home/.config/git/config-work.template"
  fi
}

# Main function
main() {
  step "Running personalization script..."

  # Check if personalized files already exist and ask about overwriting
  if ! check_existing_files; then
    header "Personalization Skipped"
    info "Continuing with existing personalized files."
    return 0
  fi

  # Setup project directories and create gitconfig
  setup_project_directories
  create_gitconfig

  # Create personalized files with user input
  create_personalized_files

  success "Personalization Complete"
}

# Run the main function
main
