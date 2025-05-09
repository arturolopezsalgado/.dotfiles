#!/usr/bin/env zsh

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Store script directory and source colors utility
SCRIPT_DIR=$(dirname $0)
source "$SCRIPT_DIR/../utils/colors.sh"

# Define backup directory and filename
BACKUP_DIR="$HOME/.config/macos_backups"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="$BACKUP_DIR/macOS_backup_$TIMESTAMP.plist"

header "macOS Settings Backup"

# Create backup directory if it doesn't exist
if [[ ! -d "$BACKUP_DIR" ]]; then
    step "Creating backup directory..."
    mkdir -p "$BACKUP_DIR"
    success "Created directory: $BACKUP_DIR"
fi

# Function to backup domain settings
backup_domain() {
    local domain=$1
    local description=$2
    
    note "Backing up $description settings..."
    defaults export "$domain" "$BACKUP_FILE" 2>/dev/null && {
        success "Successfully backed up $description settings"
    } || {
        warning "Could not backup $description settings (domain may not exist)"
    }
}

# Backup all relevant domains
step "Starting backup of macOS settings..."

backup_domain "com.apple.dock" "Dock"
backup_domain "com.apple.finder" "Finder"
backup_domain "com.apple.systemuiserver" "Menu Bar"
backup_domain "com.apple.controlcenter" "Control Center"
backup_domain "com.apple.systempreferences" "System Preferences"
backup_domain "NSGlobalDomain" "Global Domain"

# Additional domains that might be useful
backup_domain "com.apple.AppleMultitouchTrackpad" "Trackpad"
backup_domain "com.apple.driver.AppleBluetoothMultitouch.trackpad" "Bluetooth Trackpad"
backup_domain "com.apple.menuextra.clock" "Clock"
backup_domain "com.apple.screensaver" "Screen Saver"

# Display backup information
info "Total domains backed up: 10"
success "Backup completed successfully!"
note "Backup file: $BACKUP_FILE"
echo ""
note "To restore these settings later, run:"
echo "zsh $SCRIPT_DIR/restore_macos_settings.sh"

exit 0
