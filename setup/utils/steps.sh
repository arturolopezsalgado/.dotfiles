#!/usr/bin/env zsh
# This file hosts installation steps

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail


# Install GNU stow if not installed
install_gnu_stow() {
    if ! command -v stow &> /dev/null; then
        echo "Installing GNU Stow..."
        brew install stow
    else
        warning "GNU Stow is already installed."
    fi
}

overwrite_dotfiles() {
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
}

# Run brew bundle
install_brew_bundle() {
    echo -n "Run brew bundle? [y/n] "
    read run_brew_bundle

    brewfile=$DOTFILES_DIR/.config/homebrew/Brewfile
    echo "Brewfile path: $brewfile"
    if [[ "$run_brew_bundle" == "y" ]]; then
        # verify homebrew is installed
        if ! command -v brew &> /dev/null; then
            error "Homebrew is not installed. Please install Homebrew first."
            exit 1
        fi
        # Run the brew bundle command
        echo "Running brew bundle..."
        brew bundle --file="$brewfile" || {
            error "Failed to run brew bundle"
            exit 1
        }
        success "Brew bundle installed successfully"
    else
        echo "Skipping brew bundle."
    fi
}
