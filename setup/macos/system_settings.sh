#!/usr/bin/env zsh

echo "Configuring System Settings..."

# --- Windows & Apps ---
echo "→ Configuring Windows & Apps..."

# Prefer tabs: Always
defaults write NSGlobalDomain AppleWindowTabbingMode -string "always"

# Disable: Ask to keep changes when closing documents
defaults write -g NSCloseAlwaysConfirmsChanges -bool false

# Enable: Close windows when quitting apps
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Minimize to application icon
defaults write com.apple.dock minimize-to-application -bool true

# Minimize using scale effect
defaults write com.apple.dock mineffect -string "scale"

# Disable: Stage Manager (requires manual step, see below)

# Default browser — manual step (can’t reliably set via script due to system privacy restrictions)

# --- Mission Control ---
echo "→ Configuring Mission Control..."

# Disable: Automatically rearrange Spaces
defaults write com.apple.dock mru-spaces -bool false

# Enable: Switch to space with open app window
defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool true

# Disable: Group windows by application
defaults write com.apple.dock expose-group-by-app -bool false

# Enable: Displays have separate Spaces
defaults write com.apple.spaces spans-displays -bool false

# --- Notifications ---
echo "→ Configuring Notifications..."

# These preferences are not all available via `defaults`; we apply what we can:
# Show previews: "When Unlocked" — requires manual configuration
# Disable notifications while locked/sleeping/mirroring — requires manual configuration

# --- Siri & Spotlight ---
echo "→ Configuring Siri & Spotlight..."

# Remove specific Spotlight categories
defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1; "name" = "APPLICATIONS"; }' \
  '{"enabled" = 1; "name" = "SYSTEM_PREFS"; }' \
  '{"enabled" = 0; "name" = "FONTS"; }' \
  '{"enabled" = 0; "name" = "DOCUMENTS"; }' \
  '{"enabled" = 0; "name" = "MESSAGES"; }' \
  '{"enabled" = 0; "name" = "MOVIES"; }' \
  '{"enabled" = 0; "name" = "MUSIC"; }' \
  '{"enabled" = 0; "name" = "OTHER"; }' \
  '{"enabled" = 0; "name" = "PRESENTATIONS"; }' \
  '{"enabled" = 0; "name" = "SPREADSHEETS"; }' \
  '{"enabled" = 0; "name" = "TIPS"; }'

# Apply Spotlight changes
killall mds > /dev/null 2>&1
sudo mdutil -E / > /dev/null 2>&1

# --- Energy Saver ---
echo "→ Configuring Energy Saver..."

# Put hard disks to sleep
sudo pmset -a disksleep 10

# Disable wake for network access
sudo pmset -a womp 0

# Disable auto restart on power loss
sudo pmset -a autorestart 0

# --- Lock Screen ---
echo "→ Configuring Lock Screen..."

# Start screensaver = never (0 means never)
defaults -currentHost write com.apple.screensaver idleTime -int 0

# Turn off display after 10 minutes (set in Energy Saver)
sudo pmset -a displaysleep 10

# Require password after 1 hour
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 3600

# --- Trackpad & Mouse ---
echo "→ Configuring Trackpad & Mouse..."

# Tracking speed (range: 0–3; 2.5 ≈ 80%)
defaults write -g com.apple.trackpad.scaling -float 2.5
defaults write -g com.apple.mouse.scaling -float 2.5

# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable all scroll/zoom/gesture options — best done manually for fine control

# --- Restart Relevant Services ---
killall Dock
killall Finder
killall SystemUIServer

# --- Manual Instructions ---
echo
echo "⚠️  Manual Configuration Required:"
echo "Please complete the following steps manually:"
echo " → System Settings → Desktop & Dock:"
echo "    - Disable Stage Manager"
echo "    - Set Default Browser to Brave Browser"
echo
echo " → System Settings → Notifications:"
echo "    - Set 'Show Previews' to 'When Unlocked'"
echo "    - Disable notifications during sleep, lock screen, and screen sharing"
echo
echo " → System Settings → Trackpad & Mouse:"
echo "    - Enable all scroll/zoom/gesture options manually"
echo

# Instead of requiring user interaction, just proceed
echo "Continuing with setup..."
