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
. "$SCRIPT_DIR/utils/steps.sh"
. "$SCRIPT_DIR/scripts/prerequisites.sh"
. "$SCRIPT_DIR/scripts/homebrew.sh"

echo "Setting up the Mac..."

# Installation steps
install_prerequisites
overwrite_dotfiles


echo "Setup complete"
