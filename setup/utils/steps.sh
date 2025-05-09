#!/usr/bin/env zsh
#
# Installation Steps Utility
#
# This file contains the core installation functions used by the main install script.
# It provides functions for dotfiles symlinking and package installation.
#

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Guard against multiple inclusion
if [[ -n "${STEPS_SH_LOADED+x}" ]]; then
    return 0
fi
readonly STEPS_SH_LOADED=true

# Make sure colors.sh is loaded
if [[ -z "${COLORS_SH_LOADED:-}" ]]; then
    source "$(dirname "${(%):-%x}")/colors.sh"
fi

# Backup existing shell configuration files
backup_shell_files() {
    header "Backing Up Existing Shell Files"

    local backup_date=$(date +"%Y%m%d%H%M%S")
    local files_to_backup=(
        "$HOME/.zshrc"
        "$HOME/.zshenv"
        "$HOME/.zprofile"
        "$HOME/.zlogin"
        "$HOME/.zlogout"
    )
    local any_files_backed_up=false

    step "Checking for existing shell configuration files..."

    # for file in "${files_to_backup[@]}"; do
    #     if [[ -f "$file" ]]; then
    #         # If it's a symlink, unlink it first
    #         if [[ -L "$file" ]]; then
    #             unlink "$file"
    #             step "Removing symlink: $file"
    #         fi
    #     fi
    # done

    for file in "${files_to_backup[@]}"; do
        if [[ -f "$file" ]]; then
            local backup_file="${file}.bak.${backup_date}"

            # a symlink, unlink it first
            if [[ -L "$file" ]]; then
                cp "$file" "$backup_file"
                step "Backing up symlink: $file to $backup_file"
                # Unlink the symlink
                unlink "$file"
                step "Removing symlink: $file"
            else
                # If it's not a symlink, just move it
                mv "$file" "$backup_file"
                step "Backing up: $file to $backup_file"
            fi
            any_files_backed_up=true
            success "Backed up $file to $backup_file"
        fi
    done

    if [[ "$any_files_backed_up" == "false" ]]; then
        note "No existing shell configuration files found to backup"
    else
        note "Shell configuration files were backed up with extension .bak.${backup_date}"
    fi
}

# Show post-installation notes
show_post_install_notes() {
    header "Next Steps"

    note "Here are some things you should do to complete your setup:"
    echo

    # SSH key setup suggestions
    if [[ -n "${PERSONAL_SSH_KEY:-}" ]]; then
        echo "${CYAN}→ Add your personal SSH key to GitHub:${DEFAULT_COLOR}"
        echo "  cat ~/.config/ssh/${PERSONAL_SSH_KEY}.pub | pbcopy"
        echo "  Then go to: https://github.com/settings/keys"
        echo
    fi

    if [[ -n "${WORK_SSH_KEY:-}" ]]; then
        echo "${CYAN}→ Add your work SSH key to your work GitHub:${DEFAULT_COLOR}"
        echo "  cat ~/.config/ssh/${WORK_SSH_KEY}.pub | pbcopy"
        echo "  Then go to your work GitHub settings"
        echo
    fi

    # General recommendations
    echo "${CYAN}→ Configure app permissions:${DEFAULT_COLOR}"
    echo "  Open Rectangle and allow accessibility permissions"
    echo "  Configure other apps that need special permissions"
    echo

    echo "${CYAN}→ Set up browser profiles:${DEFAULT_COLOR}"
    echo "  Create personal and work profiles in Chrome and/or Brave"
    echo "  Sign in to each profile with the appropriate account"
    echo

    echo "${CYAN}→ Customize terminal appearance:${DEFAULT_COLOR}"
    echo "  Adjust font size, color scheme, and window size for your terminal"
    echo

    echo "${CYAN}→ Configure your editor:${DEFAULT_COLOR}"
    echo "  Set up VS Code or your preferred editor with your favorite extensions"
    echo

    echo "${CYAN}→ Additional customizations:${DEFAULT_COLOR}"
    echo "  Review macOS settings to ensure they're to your liking"
    echo "  Adjust Dock, Finder, and system preferences as needed"
    echo
    echo

    echo "${CYAN}→ Google Cloud SDK:${DEFAULT_COLOR}"
    echo "  In a terminal, run the following command to initialize:"
    echo "  ${MAGENTA} ❯ ${GREEN}gcloud init${DEFAULT_COLOR}"
    echo "  Follow the prompts to set up your Google Cloud SDK"
    echo "  ${MAGENTA} ❯ ${GREEN}gcloud auth application-default login${DEFAULT_COLOR}"
    echo "  This will set up your application default credentials"
    echo "  ${MAGENTA} ❯ ${GREEN}gcloud auth configure-docker us-central1-docker.pkg.dev${DEFAULT_COLOR}"
    echo "  This will configure Docker to use your Google Cloud credentials"
    echo

    note "Enjoy your newly configured macOS environment!"
}

# Install GNU stow if not installed
install_gnu_stow() {
    if ! command -v stow &> /dev/null; then
        step "Installing GNU Stow..."
        brew install stow
        success "GNU Stow installed"
    fi
}

# Create symlinks for all dotfiles
overwrite_dotfiles() {
    header "Setting Up Dotfiles"

    note "This will symlink configuration files to your home directory"
    echo -n "Proceed? [y/n] "
    read -r overwrite_dotfiles

    if [[ "$overwrite_dotfiles" == "y" || "$overwrite_dotfiles" == "Y" ]]; then
        # Ensure GNU stow is installed
        install_gnu_stow

        # Backup existing shell files
        backup_shell_files

        # Verify dotfiles directory exists
        if [[ -z "${DOTFILES_DIR:-}" ]]; then
            error "DOTFILES_DIR variable is not set"
            return 1
        fi

        # Print more information about what's happening
        step "Setting up dotfiles from: $DOTFILES_DIR"
        step "Target directory: $HOME"

        # Remove existing symlinks
        step "Removing any existing symlinks..."
        command stow --delete . --dir="$DOTFILES_DIR" --target="$HOME" 2>/dev/null || true

        # Create new symlinks
        step "Creating new symlinks..."
        command stow --target="$HOME" --dir="$DOTFILES_DIR" --stow . || {
            error "Failed to create symlinks"
            return 1
        }

        success "Dotfiles setup complete"
    else
        warning "Dotfiles setup skipped"
    fi
}

# Install packages using Homebrew
install_brew_bundle() {
    header "Package Installation"

    note "This will install packages from your Brewfile"
    echo -n "Proceed? [y/n] "
    read -r run_brew_bundle

    if [[ "$run_brew_bundle" == "y" || "$run_brew_bundle" == "Y" ]]; then
        # Get the Brewfile path
        local brewfile="$DOTFILES_DIR/.config/homebrew/Brewfile"

        # Check if Brewfile exists
        if [[ ! -f "$brewfile" ]]; then
            error "Brewfile not found at: $brewfile"
            return 1
        fi

        # Verify Homebrew is installed
        if ! command -v brew &> /dev/null; then
            error "Homebrew is not installed"
            return 1
        fi

        # Run brew bundle and capture exit code
        step "Installing packages..."
        local brew_status=0
        brew bundle --file="$brewfile" || brew_status=$?

        # Handle any failures
        if [[ $brew_status -ne 0 ]]; then
            warning "Some packages failed to install from Brewfile (status: $brew_status)"
            warning "You can try installing them manually later"
        fi

        # Cleanup
        brew cleanup

        # Show appropriate message
        if [[ $brew_status -eq 0 ]]; then
            success "All packages installed successfully"
        else
            warning "Installation completed with some package failures"
            note "Check the output above for details on failed packages"
        fi
    else
        warning "Package installation skipped"
    fi
}

# Configure macOS settings
setup_macos() {
header "macOS Configuration"

note "This will customize your macOS system preferences"
echo -n "Proceed? [y/n] "
read -r macos_choice

if [[ "$macos_choice" == "y" || "$macos_choice" == "Y" ]]; then
local macos_script="$1"
step "Applying macOS settings..."

# Run the script but continue on failure
zsh "$macos_script" || {
local result=$?
    warning "Some macOS settings could not be applied (status: $result)"
    warning "This is often due to system restrictions or permissions"
    # Continue installation despite errors
        return 0
}

    success "macOS settings applied"
    else
        warning "macOS configuration skipped"
        note "You can run it later with: zsh $1"
    fi
}

# Check if this script is being sourced or executed directly
# More reliable check that works across different zsh contexts
if [[ "$ZSH_EVAL_CONTEXT" != *:file:* && "$ZSH_EVAL_CONTEXT" != *:file ]]; then
    # Script was executed directly
    error "This is a utility script and should be sourced, not executed directly."
    exit 1
fi
