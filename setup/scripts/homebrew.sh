#!/usr/bin/env zsh

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Get parent directory of the script
# This is useful for sourcing other scripts or utilities
# without hardcoding paths
PARENT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Source the colors utility script
. "$PARENT_DIR/utils/colors.sh"

# Install GNU stow if not installed
install_gnu_stow() {
    if ! command -v stow &> /dev/null; then
        echo "Installing GNU Stow..."
        brew install stow
    else
        warning "GNU Stow is already installed."
    fi
}
