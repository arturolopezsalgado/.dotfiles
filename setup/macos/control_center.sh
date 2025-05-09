#!/usr/bin/env zsh

echo "Configuring Control Center..."

# Hide Wi-Fi and Bluetooth from the menu bar (they stay in Control Center)
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool false

# Hide Stage Manager from menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible StageManager" -bool false

# Manual configuration required for showing modules only when active
# These settings are NOT reliably scriptable in modern macOS (macOS Ventura+)

killall SystemUIServer

echo
echo "⚠️  Manual Configuration Required:"
echo "Please go to System Settings → Control Center and update the following:"
echo " 1. Airdrop:            Set to 'Don't show in Menu Bar'"
echo " 2. Focus:              Set to 'Show when Active'"
echo " 3. Stage Manager:      Confirm it's hidden from Menu Bar"
echo " 4. Screen Mirroring:   Set to 'Show when Active'"
echo " 5. Display:            Set to 'Show when Active'"
echo " 6. Sound:              Set to 'Show when Active'"
echo " 7. Now Playing:        Set to 'Show when Active'"
echo

# Instead of requiring user interaction, just proceed
echo "Continuing with setup..."
