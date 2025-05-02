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
