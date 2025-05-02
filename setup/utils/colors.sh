#!/usr/bin/env zsh
# colors.sh - Terminal color formatting utility functions
#
# This script provides utility functions for consistent color formatting
# in terminal output. It defines functions for different message types
# (info, success, error, warning) with appropriate color coding.
#
# Usage:
#   source ./colors.sh
#   info "Information message"
#   success "Success message"
#   error "Error message"
#   warning "Warning message"

# Exit immediately if a command exits with a non-zero status
set -e

# Guard against multiple inclusion
if [[ -n "${COLORS_SH_LOADED+x}" ]]; then
    return 0
fi
readonly COLORS_SH_LOADED=true

# Reset terminal formatting to default
readonly DEFAULT_COLOR="$(tput sgr0)"

# Define color codes using tput (safer than ANSI escape sequences)
readonly RED="$(tput setaf 1)"
readonly GREEN="$(tput setaf 2)"
readonly YELLOW="$(tput setaf 3)"
readonly BLUE="$(tput setaf 4)"

# Define message type labels
readonly INFO_LABEL="INFO: "
readonly SUCCESS_LABEL="SUCCESS: "
readonly ERROR_LABEL="ERROR: "
readonly WARNING_LABEL="WARNING: "

# Prefix symbol for all messages
readonly PREFIX_SYMBOL="==>"

# Check if stdout is a terminal
if [[ -t 1 ]]; then
    readonly USE_COLORS=true
else
    readonly USE_COLORS=false
fi

# Print a formatted message with specified color and label
# Args:
#   $1 - Color code
#   $2 - Label text
#   $3 - Message text
_print_formatted() {
    local color="$1"
    local label="$2"
    local message="$3"

    if [[ "$USE_COLORS" == true ]]; then
        printf "%s%s %s%s%s\n" "$color" "$PREFIX_SYMBOL" "$label" "$message" "$DEFAULT_COLOR"
    else
        # When not in a terminal, print without colors
        printf "%s %s%s\n" "$PREFIX_SYMBOL" "$label" "$message"
    fi
}

# Print an information message (blue)
# Args:
#   $1 - Message text
info() {
    _print_formatted "$BLUE" "$INFO_LABEL" "$1"
}

# Print a success message (green)
# Args:
#   $1 - Message text
success() {
    _print_formatted "$GREEN" "$SUCCESS_LABEL" "$1"
}

# Print an error message (red)
# Args:
#   $1 - Message text
error() {
    _print_formatted "$RED" "$ERROR_LABEL" "$1"
}

# Print a warning message (yellow)
# Args:
#   $1 - Message text
warning() {
    _print_formatted "$YELLOW" "$WARNING_LABEL" "$1"
}

# Check if script is being sourced or executed directly
# if [[ "${(%):-%N}" == "$0" ]]; then
#     # Script was executed directly, show usage example
#     echo "Color utility functions:"
#     info "This is an information message (blue)"
#     success "This is a success message (green)"
#     error "This is an error message (red)"
#     warning "This is a warning message (yellow)"
#     echo -e "\nTo use these functions in your scripts:"
#     echo "  source $(basename "$0")"
# fi
