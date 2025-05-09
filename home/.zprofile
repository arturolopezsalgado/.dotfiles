# ~/.zprofile
# Executed for login shells, before .zshrc
# This is the recommended file for setting PATH and environment variables
# that should be available to both login shells and processes started from login shells

# Load modular profile files
ZSH_PROFILE_DIR="$HOME/.config/zsh/profile"

# Source profile modules if directory exists
if [[ -d "$ZSH_PROFILE_DIR" ]]; then
  for module in "$ZSH_PROFILE_DIR"/*.zsh; do
    if [[ -r "$module" ]]; then
      source "$module"
    fi
  done
fi

# Load machine-specific profile if it exists
[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
