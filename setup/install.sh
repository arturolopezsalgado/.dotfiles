#!/usr/bin/env zsh
# This script:
# - Installs

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Get the absolute path of the directory where the script is located
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source installation scripts
. "$SCRIPT_DIR/utils/colors.sh"
. "$SCRIPT_DIR/scripts/prerequisites.sh"

echo "Setting up the Mac..."
echo "Running prerequisites script..."

# Run prerequisites
detect_architecture
install_xcode
install_homebrew

echo "Setup complete"
