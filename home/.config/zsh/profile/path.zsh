# PATH configuration in .zprofile
# This runs after /etc/zprofile which uses path_helper
# Focus on development tool paths that should be properly ordered

# Programming languages and development tools

# Ruby
if [[ -d "$HOMEBREW_PREFIX/opt/ruby/bin" ]]; then
    export PATH="$HOMEBREW_PREFIX/opt/ruby/bin:$PATH"
    # Add gem binaries to path if directory exists
    if [[ -d "$HOMEBREW_PREFIX/lib/ruby/gems/3.4.0/bin" ]]; then
        export PATH="$HOMEBREW_PREFIX/lib/ruby/gems/3.4.0/bin:$PATH"
    fi
fi

# Python versions
export PATH="$HOMEBREW_PREFIX/opt/python@3.12/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/python@3.11/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/python@3.10/bin:$PATH"

# Go binaries
if [[ -d "$HOME/go/bin" ]]; then
    export PATH="$HOME/go/bin:$PATH"
fi

# Add Visual Studio Code command line tools if installed
if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]]; then
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

# Google Cloud SDK
if [[ -d "$HOMEBREW_PREFIX/share/google-cloud-sdk" ]]; then
    export PATH="$HOMEBREW_PREFIX/share/google-cloud-sdk/bin:$PATH"
    export CLOUDSDK_PYTHON=python3.11
fi
