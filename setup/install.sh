#!/usr/bin/env zsh
# This script:
# - Installs

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Get the absolute path directories
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly DOTFILES_DIR="$(cd "$SCRIPT_DIR/../home" && pwd)"

# Source installation scripts
. "$SCRIPT_DIR/utils/colors.sh"
. "$SCRIPT_DIR/scripts/prerequisites.sh"
. "$SCRIPT_DIR/scripts/homebrew.sh"

echo "Setting up the Mac..."

# Install prerequisites
install_prerequisites

echo -n "Overwrite existing dotfiles? [y/n] "
read overwrite_dotfiles

if [[ "$overwrite_dotfiles" == "y" ]]; then
    # Run the dotfiles installation script
    install_gnu_stow

    echo "Dotfiles directory: $DOTFILES_DIR"
    # Remove existing symlinks
    echo "Deleting existing symlinks..."
    command stow --delete . --dir="$DOTFILES_DIR" --target="$HOME" || {
        error "Failed to delete existing symlinks"
        exit 1
    }
    # Stow the dotfiles
    echo "Stowing dotfiles..."
    command stow --target="$HOME" --dir="$HOME/.dotfiles/home" --stow . || {
        error "Failed to stow dotfiles"
        exit 1
    }
    success "Dotfiles stowed successfully"
else
    echo "Keeping existing dotfiles."
fi

echo "Setup complete"
