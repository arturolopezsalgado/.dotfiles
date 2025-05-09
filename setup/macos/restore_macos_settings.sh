#!/usr/bin/env zsh

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Store script directory and source colors utility
SCRIPT_DIR=$(dirname $0)
source "$SCRIPT_DIR/../utils/colors.sh"

header "macOS Settings Restoration"

# Define backup directory
BACKUP_DIR="$HOME/.config/macos_backups"

# Check if backup directory exists and is not empty
if [[ ! -d "$BACKUP_DIR" || -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
    error "No backups found in $BACKUP_DIR"
    note "Please ensure you've previously run the backup script."
    exit 1
fi

# Display available backups
info "Available backups:"
ls -1t "$BACKUP_DIR" | grep -E "macOS_backup_[0-9]+\.plist" | awk '{print NR". "$0}'

# Prompt user to select a backup
note "Enter the number of the backup to restore, or 'q' to quit:"
read -r selection

# Exit if user chooses to quit
if [[ "$selection" == "q" || "$selection" == "Q" ]]; then
    warning "Restoration cancelled by user."
    exit 0
fi

# Validate selection
if ! [[ "$selection" =~ ^[0-9]+$ ]]; then
    error "Invalid selection. Please enter a number."
    exit 1
fi

# Get the selected backup file
selected_backup=$(ls -1t "$BACKUP_DIR" | grep -E "macOS_backup_[0-9]+\.plist" | sed -n "${selection}p")

if [[ -z "$selected_backup" ]]; then
    error "Invalid selection. No backup found with that number."
    exit 1
fi

BACKUP_FILE="$BACKUP_DIR/$selected_backup"

info "Selected backup: $selected_backup"
warning "This will restore your macOS settings to the state saved in this backup."
echo "Do you want to proceed? (y/n)"
read -r confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    warning "Restoration cancelled by user."
    exit 0
fi

# Create a backup of current settings before restoring (safety measure)
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
SAFETY_BACKUP="$BACKUP_DIR/pre_restore_backup_$TIMESTAMP.plist"

step "Creating safety backup of current settings..."
# Backup key preferences
defaults export com.apple.dock "$SAFETY_BACKUP"
defaults export com.apple.finder "$SAFETY_BACKUP"
defaults export com.apple.systemuiserver "$SAFETY_BACKUP"
defaults export com.apple.systempreferences "$SAFETY_BACKUP"
success "Safety backup created at: $SAFETY_BACKUP"

# Restore settings
step "Restoring settings from backup..."

# Function to safely restore preferences
restore_preferences() {
    local domain=$1
    note "   Restoring $domain preferences..."
    defaults import "$domain" "$BACKUP_FILE" 2>/dev/null || warning "   No $domain settings found in backup"
}

# Restore key macOS preferences
restore_preferences "com.apple.dock"
restore_preferences "com.apple.finder"
restore_preferences "com.apple.systemuiserver"
restore_preferences "com.apple.systempreferences"
restore_preferences "com.apple.controlcenter"
restore_preferences "NSGlobalDomain"

# Restart affected services
step "Applying restored settings..."
killall Finder &>/dev/null || true
killall Dock &>/dev/null || true
killall SystemUIServer &>/dev/null || true

success "Restoration complete!"
note "Your macOS settings have been restored from: $selected_backup"
info "A safety backup of your previous settings was created at: $SAFETY_BACKUP"
note "If you need to revert to the settings before this restoration, you can use the safety backup."

exit 0
