# XDG Base directory specification
# Defines standard locations for user-specific files
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

export XDG_CONFIG_HOME="$HOME/.config"         # Configuration files
export XDG_CACHE_HOME="$HOME/.cache"           # Non-essential cached data
export XDG_DATA_HOME="$HOME/.local/share"      # Data files
export XDG_STATE_HOME="$HOME/.local/state"     # State files (logs, history, etc.)

# XDG compatible SSH configuration
export SSH_CONFIG_DIR="$XDG_CONFIG_HOME/ssh"    # SSH configuration files

# Create directories if they don't exist
mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_CACHE_HOME
mkdir -p $XDG_DATA_HOME
mkdir -p $XDG_STATE_HOME
mkdir -p $SSH_CONFIG_DIR
