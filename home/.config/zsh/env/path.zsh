# PATH configuration for all shell types
# Basic PATH essentials needed by all shells
# More specific PATH additions should go in profile/path.zsh

# Ensure /usr/local/bin is ahead of /usr/bin
export PATH="/usr/local/bin:$PATH"

# Homebrew architecture detection 
if [[ "$(uname -m)" == "arm64" ]]; then
    # Apple Silicon
    export HOMEBREW_PREFIX="/opt/homebrew"
else
    # Intel
    export HOMEBREW_PREFIX="/usr/local"
fi

# Add the homebrew bin directory to PATH
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"

# User local bin directory
export PATH="$HOME/.local/bin:$PATH"
