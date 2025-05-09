# System configuration in .zprofile
# Setup for login shells that needs to be available before .zshrc

# Set up pager (editor is already set in env/editor.zsh)
export PAGER="less"

# Java configuration
if [[ -x "/usr/libexec/java_home" ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
fi

# Local time zone
export TZ="America/Mexico_City"

# Python environment
export PYTHONDONTWRITEBYTECODE=1  # Don't write .pyc files
export PYTHONUNBUFFERED=1         # Don't buffer stdout/stderr

# Node.js environment
export NODE_ENV="development"

# Poetry Python package manager
export POETRY_VIRTUALENVS_IN_PROJECT=true
