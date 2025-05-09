# macOS specific settings in .zprofile

# Prevent creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Enable developer mode (avoid frequent password prompts)
if [[ -x "/usr/sbin/DevToolsSecurity" ]]; then
  # Only run if developer mode is not already enabled
  if ! /usr/sbin/DevToolsSecurity -status | grep -q "enabled"; then
    sudo /usr/sbin/DevToolsSecurity -enable &>/dev/null
  fi
fi

# Configure homebrew
export HOMEBREW_NO_ANALYTICS=1          # Don't send analytics
export HOMEBREW_NO_AUTO_UPDATE=1        # Don't auto-update
export HOMEBREW_BUNDLE_NO_UPGRADE=1     # Don't auto-upgrade

# Configure caching directories that are better outside the default locations
export HOMEBREW_CACHE="$XDG_CACHE_HOME/homebrew"
export PIP_CACHE_DIR="$XDG_CACHE_HOME/pip"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"
