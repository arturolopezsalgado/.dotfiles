#!/usr/bin/env zsh

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source our colors utility script
# shellcheck source=./colors.sh
. "$SCRIPT_DIR/../utils/colors.sh"

# Detect Mac architecture
detect_architecture() {
    local arch
    arch="$(uname -m)"

    if [[ "$arch" == "arm64" ]]; then
        info "Detected Apple Silicon (ARM) Mac"
        readonly IS_ARM=true
    elif [[ "$arch" == "x86_64" ]]; then
        info "Detected Intel Mac"
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
