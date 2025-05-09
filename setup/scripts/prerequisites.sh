#!/usr/bin/env zsh
#
# Mac Development Environment Prerequisites Script
#
# This script automates the setup of prerequisites for a development environment on macOS.
# It detects the Mac architecture (Intel or Apple Silicon), installs Xcode
# Command Line Tools, and sets up Homebrew package manager with appropriate
# configurations based on the detected architecture.
#
# Usage (as a sourced script):
#   source prerequisites.sh
#   install_prerequisites
#
# Dependencies:
#   - colors.sh utility script for terminal output formatting
#

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Get parent directory of the script
PARENT_DIR="$(cd "$(dirname "${(%):-%x}")/.." && pwd)"

# Make sure colors.sh is loaded
if [[ -z "${COLORS_SH_LOADED:-}" ]]; then
    source "$PARENT_DIR/utils/colors.sh"
fi

# Global variables to store architecture info
IS_ARM=false

# Detect Mac architecture
detect_architecture() {
    local arch
    arch="$(uname -m)"

    if [[ "$arch" == "arm64" ]]; then
        info "Architecture detected: Apple Silicon (ARM) Mac"
        IS_ARM=true
    elif [[ "$arch" == "x86_64" ]]; then
        info "Architecture detected: Intel Mac"
        IS_ARM=false
    else
        error "Unsupported architecture: $arch"
        exit 1
    fi
}

# Install Xcode Command Line Tools
# These are required for Git, Homebrew, and other development tools
install_xcode() {
    header "Xcode Command Line Tools"

    # Check if already installed
    if xcode-select -p &>/dev/null; then
        warning "Xcode Command Line Tools are already installed"
        return 0
    fi

    # Start installation
    step "Starting Xcode Command Line Tools installation..."
    xcode-select --install

    # Prompt user to complete installation
    note "A dialog box should have appeared to install the Command Line Tools."
    echo "Please complete the installation and press Enter to continue..."
    read -r

    # Accept license
    step "Accepting Xcode license (may require password)..."
    sudo xcodebuild -license accept

    success "Xcode Command Line Tools installed successfully"
}

# Install Homebrew
install_homebrew() {
    header "Homebrew Package Manager"

    # Set default Homebrew installation options
    export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
    export HOMEBREW_NO_ANALYTICS=1  # Respect privacy by disabling analytics

    # Check if already installed
    if hash brew &>/dev/null; then
        warning "Homebrew is already installed"

        # Update Homebrew to ensure it's current
        step "Updating Homebrew..."
        brew update
        success "Homebrew updated successfully"
        return 0
    fi

    # Validate sudo credentials before running installer
    step "Preparing for installation (may require password)..."
    sudo --validate

    # Run Homebrew installer
    step "Running Homebrew installer (this may take a while)..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for ARM Macs if needed
    if [[ "$IS_ARM" == true ]]; then
        if [[ -d "/opt/homebrew/bin" ]]; then
            step "Configuring Homebrew PATH for Apple Silicon..."

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
                note "Added Homebrew to your $shell_profile"
            fi

            # Set for current session (make sure this executes in the current shell)
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="/opt/homebrew/bin:$PATH"
      step "Added /opt/homebrew/bin to PATH for current session"
      echo "Current PATH: $PATH"
    fi
        fi
    fi

    success "Homebrew installed successfully"
}

# Main function
install_prerequisites() {
    header "macOS Prerequisites Setup"

    # Detect Mac architecture
    detect_architecture

    # Run installation steps
    install_xcode
    install_homebrew

    success "Prerequisites setup completed successfully!"
    note "You can now install packages using 'brew install <package>'"
}

# Check if this script is being sourced or executed directly
if [[ "${(%):-%N}" == "$0" && -z "${SOURCED_ONLY:-}" ]]; then
    # Script was executed directly, run the main function
    install_prerequisites
fi
