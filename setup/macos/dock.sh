#!/usr/bin/env zsh

# Source utilities
SCRIPT_DIR=$(dirname $0)
source "$SCRIPT_DIR/../utils/colors.sh"

# Ensure dockutil is installed
if ! command -v dockutil &> /dev/null; then
  info "Installing dockutil..."

  # For newer macOS versions (Sonoma and newer), use the lotyp fork
  # if [[ $(sw_vers -productVersion | cut -d. -f1) -ge 14 ]]; then
  #   brew install lotyp/formulae/dockutil
  # else
    brew install dockutil
  # fi

  success "dockutil installed"
fi

# Get dockutil version for debugging
DOCKUTIL_VERSION=$(dockutil --version 2>/dev/null || echo "Unknown")
info "Using dockutil version: $DOCKUTIL_VERSION"

step "Configuring Dock..."

# Clear Dock
info "Removing all existing items from Dock..."
dockutil --remove all --no-restart

# Function to verify app exists before attempting to add to dock
function add_app_to_dock() {
  local app_path="$1"
  if [[ -e "$app_path" ]]; then
    info "Adding to dock: $(basename "$app_path")"
    dockutil --add "$app_path" --no-restart
    return 0
  else
    warning "App not found, skipping: $app_path"
    return 1
  fi
}

# Apps to keep in Dock
essential_apps=(
  "/System/Applications/Finder.app"
  "/System/Applications/Launchpad.app"
  "System/Applications/Mission%20Control.app"
  "/System/Applications/System%20Settings.app"
  "/System/Applications/Utilities/Activity%20Monitor.app"
  "$HOME/Downloads"
)

# Personalized apps to add - ordered by priority
custom_apps=(
  "/Applications/1Password%207.app"
  "/Applications/Applications/Visual%20Studio%20Code.app"
  "/Applications/Ghostty.app"
  "/Applications/Slack.app"
  "/Applications/Google%20Chrome.app"
  "/Applications/Brave%20Browser.app"
  "/Applications/Postman.app"
  "/Applications/DBeaver.app"
  "/Applications/Docker%20Desktop.app"
  "/Applications/superwhisper.app"
  "/Applications/Claude.app"
)

# First add essential apps
info "Adding essential apps to dock..."
for app in "${essential_apps[@]}"; do
  add_app_to_dock "$app"
done

# Then add custom apps if they exist
info "Adding custom apps to dock..."
for app in "${custom_apps[@]}"; do
  add_app_to_dock "$app"
done

# Add trash to the end of the dock
info "Adding trash to dock..."
dockutil --add "/System/Library/CoreServices/Dock.app/Contents/Resources/trashcan.app" --no-restart

# Dock settings
info "Applying dock preferences..."
defaults write com.apple.dock tilesize -int 32                     # reduce size
defaults write com.apple.dock magnification -bool false            # disable magnification
defaults write com.apple.dock orientation -string "bottom"         # dock on bottom
defaults write com.apple.dock mineffect -string "scale"            # scale minimize effect
defaults write com.apple.dock minimize-to-application -bool true   # minimize into app icon
defaults write com.apple.dock autohide -bool true                  # auto-hide
defaults write com.apple.dock launchanim -bool false               # disable opening animation
defaults write com.apple.dock show-process-indicators -bool true   # show indicators
defaults write com.apple.dock show-recents -bool false             # disable recent apps

# Restart Dock to apply settings
info "Restarting Dock to apply changes..."
killall Dock

success "Dock configuration complete."
