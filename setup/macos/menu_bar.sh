#!/usr/bin/env zsh

echo "Configuring Menu Bar..."

# --- System Icons ---

# Hide Spotlight icon
defaults write com.apple.Spotlight "MenuItemHidden" -bool true

# Hide Siri icon
defaults write com.apple.Siri StatusMenuVisible -bool false

# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Hide Wi-Fi and Bluetooth from menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool false

# Hide Time Machine icon from menu bar
defaults write com.apple.TimeMachine MenuItemVisible -bool false

# --- Clock Settings ---

# Use 24-hour time format
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Show day of week (via custom format)
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  H:mm"

killall SystemUIServer

echo
echo "⚠️  Manual Configuration Required:"
echo "Please perform the following steps manually:"
echo " 1. System Settings → Control Center:"
echo "    - Set Airdrop, Stage Manager, Screen Mirroring, Display, Sound, Now Playing to 'Show when Active'"
echo "    - Set Focus to 'Show when Active'"
echo " 2. System Settings → Control Center → Clock Options:"
echo "    - Set 'Show date' to 'When space allows'"
echo

# Instead of requiring user interaction, just proceed
echo "Continuing with setup..."
