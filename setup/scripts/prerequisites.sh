#!/usr/bin/env zsh

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Get the absolute path of the directory where the script is located
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo $SCRIPT_DIR
# Source our colors utility script
# shellcheck source=./colors.sh
. "$SCRIPT_DIR/../utils/colors.sh"
