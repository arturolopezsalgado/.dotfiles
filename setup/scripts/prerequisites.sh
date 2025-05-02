#!/usr/bin/env zsh
#
# Mac Development Environment Setup Script
#
# This script automates the setup of a development environment on macOS.
# It detects the Mac architecture (Intel or Apple Silicon), installs Xcode
# Command Line Tools, and sets up Homebrew package manager with appropriate
# configurations based on the detected architecture.
#
# The script uses strict error handling and includes helper functions for
# architecture detection and installation of required development tools.
#
# Dependencies:
#   - colors.sh utility script for terminal output formatting
#

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Get parent directory of the script
# This is useful for sourcing other scripts or utilities
# without hardcoding paths
PARENT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Source the colors utility script
. "$PARENT_DIR/utils/colors.sh"

# Detect Mac architecture
detect_architecture() {
    local arch
    arch="$(uname -m)"

    if [[ "$arch" == "arm64" ]]; then
        info "Architecture detected Apple Silicon (ARM) Mac"
        readonly IS_ARM=true
    elif [[ "$arch" == "x86_64" ]]; then
        info "Architecture detected Intel Mac"
        readonly IS_ARM=false
    else
        error "Unsupported architecture: $arch"
        exit 1
    fi
}

# Install Xcode Command Line Tools
# These are required for Git, Homebrew, and other development tools
install_xcode() {
    info "Installing Apple's Command Line Tools (prerequisite for Git and Homebrew)..."

    # Check if already installed
    if xcode-select -p &>/dev/null; then
        warning "Xcode Command Line Tools are already installed"
        return 0
    fi

    # Start installation
    xcode-select --install

    # Prompt user to complete installation
    echo "A dialog box should have appeared to install the Command Line Tools."
    echo "Please complete the installation and press Enter to continue..."
    read -r

    # Accept license
    sudo xcodebuild -license accept

    success "Xcode Command Line Tools installed successfully"
}

# Install Homebrew
install_homebrew() {
    info "Installing Homebrew package manager..."

    # Set default Homebrew installation options
    export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
    export HOMEBREW_NO_ANALYTICS=1  # Respect privacy by disabling analytics

    # Check if already installed
    if hash brew &>/dev/null; then
        warning "Homebrew is already installed"

        # Update Homebrew to ensure it's current
        info "Updating Homebrew..."
        brew update
        success "Homebrew updated successfully"
        return 0
    fi

    # Validate sudo credentials before running installer
    info "Preparing for installation (may require password)..."
    sudo --validate

    # Run Homebrew installer
    info "Running Homebrew installer (this may take a while)..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for ARM Macs if needed
    if [[ "${IS_ARM:-false}" == true ]]; then
        if [[ -d "/opt/homebrew/bin" ]]; then
            info "Configuring Homebrew PATH for Apple Silicon..."

            # Check which shell the user is using
            local shell_profile
            case "$SHELL" in
                */zsh)
                    shell_profile="$HOME/.zprofile"
                    ;;
                */bash)
                    shell_profile="$HOME/.bash_profile"
                    ;;
                *)
                    shell_profile="$HOME/.profile"
                    ;;
            esac

            # Add Homebrew to PATH if not already there
            if ! grep -q "/opt/homebrew/bin" "$shell_profile" 2>/dev/null; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$shell_profile"
                info "Added Homebrew to your $shell_profile"
            fi

            # Set for current session
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi

    success "Homebrew installed successfully"
}
