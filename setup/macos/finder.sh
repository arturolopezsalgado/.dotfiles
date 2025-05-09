#!/usr/bin/env zsh

echo "Configuring Finder..."

# View as list
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show Path Bar and Status Bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Desktop icons
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# Finder windows open to ~/dev
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/dev/"

# Open folders in new windows instead of tabs
defaults write com.apple.finder FinderSpawnTab -bool false

# Disable all tags
defaults write com.apple.finder FavoriteTagNames -array
defaults write com.apple.finder ShowRecentTags -bool false

# Advanced settings
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write NSGlobalDomain _FXSortFoldersFirstOnDesktop -bool true

defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Reset Finder to apply
killall Finder

echo
echo "⚠️  Manual Configuration Required:"
echo "Please complete the following steps manually:"
echo " 1. Finder > Preferences > Sidebar:"
echo "    - Uncheck Recents, On My Mac, Movies, Music, Pictures, Shared"
echo " 2. Finder > Toolbar:"
echo "    - Right-click toolbar, remove 'Tags', add 'Path'"
echo

# Instead of requiring user interaction, just proceed
echo "Continuing with setup..."
