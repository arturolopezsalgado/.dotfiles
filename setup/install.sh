#!/usr/bin/env zsh
#
# Dotfiles Installation Script
#
# This is the main script for setting up your macOS development environment.
# It configures your shell, installs necessary tools, and applies your preferences.
#
# Usage:
#   zsh ~/.dotfiles/setup/install.sh
#

# Debug line to check execution context
echo "SCRIPT DEBUG: This script is being executed as: $(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Flag to indicate scripts are being sourced only, don't auto-execute
export SOURCED_ONLY=true

# Flag to indicate we're running an installation
export DOTFILES_INSTALLATION=true

# Get the absolute path directories
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly DOTFILES_DIR="$(cd "$SCRIPT_DIR/../home" && pwd)"
readonly REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/steps.sh"
# Import prerequisites script
source "$SCRIPT_DIR/scripts/prerequisites.sh"

# Import SSH configuration script
source "$SCRIPT_DIR/scripts/ssh_config.sh"

# Function to handle errors
handle_error() {
    local exit_code=$?
    error "Installation failed with exit code $exit_code"
    exit $exit_code
}

# Set up trap to catch errors
trap handle_error ERR INT TERM

# Set executable permissions on all scripts
set_executable_permissions() {
    step "Setting executable permissions..."

    find "$REPO_ROOT" -type f -name "*.sh" | while read -r script; do
        chmod +x "$script"
    done

    success "Scripts are now executable"
}

# Run personalization script
run_personalization() {
    header "Git and Directory Personalization"
    step "Running personalization script to configure git and project directories..."
    zsh "$SCRIPT_DIR/scripts/personalize.sh"
    success "Personalization complete"
}

# Main installation function
main() {
    header "macOS Dotfiles Setup"

    # Initial confirmation
    note "Setup will configure shell, tools, and system preferences"
    echo -n "Proceed with installation? [y/n] "
    read -r proceed_choice
    if [[ "$proceed_choice" != "y" && "$proceed_choice" != "Y" ]]; then
        warning "Installation cancelled"
        exit 0
    fi

    # DEBUGGING: Uncomment steps one by one as needed

    # # Step 1: Set executable permissions
    # echo "DEBUG: About to set executable permissions"
    set_executable_permissions
    # echo "DEBUG: Executable permissions set"

    # # Step 2: Run personalization
    # echo "DEBUG: About to run personalization"
    run_personalization
    # echo "DEBUG: Personalization complete"

    # # Step 3: Install prerequisites
    # echo "DEBUG: About to install prerequisites"
    install_prerequisites
    # echo "DEBUG: Prerequisites installed"

    # # Step 5: Set up dotfiles with stow
    # echo "DEBUG: About to set up dotfiles"
    overwrite_dotfiles
    # echo "DEBUG: Dotfiles set up"

    # # Step 6: Configure SSH
    # echo "DEBUG: About to configure SSH"
    setup_ssh_config
    # echo "DEBUG: SSH configured"

    # # Step 7: Install additional packages
    # echo "DEBUG: About to install packages"
    install_brew_bundle
    # echo "DEBUG: Packages installed"

    # # Step 8: Configure macOS
    # echo "DEBUG: About to configure macOS"
    # setup_macos "$SCRIPT_DIR/macos/macos_setup.sh"
    # echo "DEBUG: macOS configured"

    # # Step 9: Show post-installation notes
    # echo "DEBUG: About to show post-install notes"
    show_post_install_notes
    # echo "DEBUG: Post-install notes shown"

    header "Setup Complete"
    note "Restart your terminal to apply changes"
}

# Run the main function
main

# Remove the error trap before exiting
trap - ERR INT TERM
exit 0
