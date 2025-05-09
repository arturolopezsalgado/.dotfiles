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
readonly MAGENTA="$(tput setaf 5)"
readonly CYAN="$(tput setaf 6)"
readonly WHITE="$(tput setaf 7)"

# Define text styles
readonly BOLD="$(tput bold)"
readonly UNDERLINE="$(tput smul)"
readonly REVERSE="$(tput rev)"

# Define message type labels
readonly INFO_LABEL="INFO: "
readonly SUCCESS_LABEL="SUCCESS: "
readonly ERROR_LABEL="ERROR: "
readonly WARNING_LABEL="WARNING: "
readonly NOTE_LABEL="NOTE: "
readonly DEBUG_LABEL="DEBUG: "
readonly STEP_LABEL="STEP: "

# Prefix symbols for different message types
readonly PREFIX_SYMBOL="==>"
readonly SUCCESS_SYMBOL="✓"
readonly ERROR_SYMBOL="✗"
readonly WARNING_SYMBOL="⚠️"
readonly INFO_SYMBOL="ℹ️"
readonly STEP_SYMBOL="→"

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
#   $4 - Symbol (optional)
_print_formatted() {
    local color="$1"
    local label="$2"
    local message="$3"
    local symbol="${4:-$PREFIX_SYMBOL}"

    if [[ "$USE_COLORS" == true ]]; then
        printf "%s%s %s%s%s\n" "$color" "$symbol" "$label" "$message" "$DEFAULT_COLOR"
    else
        # When not in a terminal, print without colors
        printf "%s %s%s\n" "$symbol" "$label" "$message"
    fi
}

# Print an information message (blue)
# Args:
#   $1 - Message text
info() {
    _print_formatted "$BLUE" "$INFO_LABEL" "$1" "$INFO_SYMBOL"
}

# Print a success message (green)
# Args:
#   $1 - Message text
success() {
    _print_formatted "$GREEN" "$SUCCESS_LABEL" "$1" "$SUCCESS_SYMBOL"
}

# Print an error message (red)
# Args:
#   $1 - Message text
error() {
    _print_formatted "$RED" "$ERROR_LABEL" "$1" "$ERROR_SYMBOL"
}

# Print a warning message (yellow)
# Args:
#   $1 - Message text
warning() {
    _print_formatted "$YELLOW" "$WARNING_LABEL" "$1" "$WARNING_SYMBOL"
}

# Print a note message (cyan)
# Args:
#   $1 - Message text
note() {
    _print_formatted "$CYAN" "$NOTE_LABEL" "$1"
}

# Print a step message (cyan - for progress steps)
# Args:
#   $1 - Message text
step() {
    _print_formatted "$CYAN" "$STEP_LABEL" "$1" "$STEP_SYMBOL"
}

# Print a debug message (magenta - only when DEBUG is set)
# Args:
#   $1 - Message text
debug() {
    if [[ -n "${DEBUG:-}" ]]; then
        _print_formatted "$MAGENTA" "$DEBUG_LABEL" "$1"
    fi
}

# Print a header (centered, bold)
# Args:
#   $1 - Header text
header() {
    local message="$1"
    local term_width
    
    # Get terminal width or default to 80
    if command -v tput >/dev/null 2>&1; then
        term_width=$(tput cols) || term_width=80
    else
        term_width=80
    fi
    
    # Calculate padding
    local padding_length=$(( (term_width - ${#message} - 4) / 2 ))
    local padding=""
    
    for ((i=0; i<padding_length; i++)); do
        padding+="="
    done
    
    if [[ "$USE_COLORS" == true ]]; then
        printf "\n%s%s %s %s%s\n\n" "$BLUE$BOLD" "$padding" "$message" "$padding" "$DEFAULT_COLOR"
    else
        printf "\n%s %s %s\n\n" "$padding" "$message" "$padding"
    fi
}

# Check if script is being sourced or executed directly
# More reliable check that works across different zsh contexts
if [[ "$ZSH_EVAL_CONTEXT" != *:file* && "$ZSH_EVAL_CONTEXT" != *:file:* && -z "${DOTFILES_INSTALLATION:-}" ]]; then
    # Script was executed directly, show usage information
    echo "Color utility functions loaded."
    echo -e "\nTo use these functions in your scripts:"
    echo "  source $(basename "$0")"
    echo "\nSet DEBUG=1 before sourcing to enable debug messages."
    
    # Commented out examples to avoid excessive output
    # header "COLORS UTILITY DEMO"
    # info "This is an information message (blue)"
    # success "This is a success message (green)"
    # error "This is an error message (red)"
    # warning "This is a warning message (yellow)"
    # note "This is a note message (cyan)"
    # step "This is a step message with arrow (cyan)"
    # debug "This is a debug message (magenta, only visible when DEBUG=1)"
fi
