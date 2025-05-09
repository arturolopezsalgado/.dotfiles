#!/usr/bin/env zsh

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Store script directory
SCRIPT_DIR=$(dirname $0)

# Source the colors utility
source "$SCRIPT_DIR/../utils/colors.sh"

# Function to handle errors and restore settings if needed
handle_error() {
    local exit_code=$?
    error "Error occurred with exit code $exit_code"
    warning "Script execution was interrupted."

    echo "\nWould you like to restore previous settings? (y/n)"
    read -r restore_after_error
    if [[ "$restore_after_error" == "y" || "$restore_after_error" == "Y" ]]; then
        step "Restoring previous settings..."
        zsh "$SCRIPT_DIR/restore_macos_settings.sh"
        success "Previous settings have been restored."
    else
        warning "Settings were not restored. Some changes may have been applied."
    fi

    exit $exit_code
}

# Set up trap to catch errors
trap handle_error ERR INT TERM

header "macOS Personalization Setup"

# Ask for confirmation before starting
info "This script will personalize your macOS settings, including:"
echo " - Dock appearance and behavior"
echo " - Menu bar configuration"
echo " - Finder preferences"
echo " - Control Center settings"
echo " - System-wide preferences\n"

note "A backup of your current settings will be created before any changes."
echo "Do you want to proceed with macOS personalization? (y/n)"
read -r proceed_choice

if [[ "$proceed_choice" != "y" && "$proceed_choice" != "Y" ]]; then
    warning "Setup cancelled by user."
    exit 0
fi

# Backup current settings
step "Creating backup of current settings..."
zsh "$SCRIPT_DIR/backup_macos_settings.sh"
success "Backup completed successfully"

# Function to run a script and check its success
run_script() {
    local script_name=$1
    local script_description=$2

    step "$script_description..."

    # Run the script and capture its exit status
    zsh "$SCRIPT_DIR/$script_name"
    local script_status=$?

    # Check if the script succeeded
    if [ $script_status -eq 0 ]; then
        success "$script_description completed successfully"
        return 0
    else
        error "$script_description failed with status $script_status"
        return $script_status
    fi
}

# Array of scripts to run
declare -a scripts=(
    "dock.sh:Configuring Dock"
    "menu_bar.sh:Configuring Menu Bar"
    "finder.sh:Configuring Finder"
    "control_center.sh:Configuring Control Center"
    "system_settings.sh:Applying System Settings"
)

# Track if any script failed
had_errors=0

# Run all scripts
for script_info in "${scripts[@]}"; do
    script_name=${script_info%%:*}
    script_desc=${script_info#*:}
    
    run_script "$script_name" "$script_desc" || {
        had_errors=1
        error "Error detected in $script_name"
        # Continue with remaining scripts by default
        warning "Continuing with remaining scripts..."
    }
done

header "macOS Personalization Status"

if [ $had_errors -eq 1 ]; then
    warning "Some personalization scripts encountered errors."
    warning "You may need to configure some settings manually."
    note "Your backup is available if needed."
    info "All available changes have been applied"
    success "macOS personalization completed with some warnings"
else
    success "All personalization scripts completed successfully!"
    info "Your macOS personalization is complete!"
fi

note "If you need to restore settings later, you can run:"
echo "zsh $SCRIPT_DIR/restore_macos_settings.sh"

# Remove the error trap before exiting
trap - ERR INT TERM
exit 0
