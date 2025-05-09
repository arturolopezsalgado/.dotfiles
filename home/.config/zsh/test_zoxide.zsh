#!/usr/bin/env zsh

# Test script for debugging zoxide and fzf integration

# Get zoxide function definition
which __zoxide_zi

# Check fzf installation
which fzf
fzf --version

# Environment variables
echo "_ZO_FZF_OPTS: ${_ZO_FZF_OPTS:-not set}"

# Test direct call to internal zoxide function
echo "Testing direct call to __zoxide_zi:"
__zoxide_zi 2>&1

exit 0
