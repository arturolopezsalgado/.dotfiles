# Editor configuration
# Sets up default editors for various programs

# Default editor
export EDITOR="/usr/local/bin/nvim"
export VISUAL="$EDITOR"

# For tools that specifically look for these
export GIT_EDITOR="code --wait"
export SVN_EDITOR="$EDITOR"

# Make man pages more readable with color
export MANPAGER="less -FRX"

# Less configuration
export LESS="-F -g -i -M -R -S -w -X -z-4"
export LESS_TERMCAP_md=$'\E[01;31m'      # bold mode - red
export LESS_TERMCAP_me=$'\E[0m'          # end mode
export LESS_TERMCAP_se=$'\E[0m'          # end standout-mode
export LESS_TERMCAP_so=$'\E[00;47;30m'   # standout-mode - black on grey
export LESS_TERMCAP_ue=$'\E[0m'          # end underline
export LESS_TERMCAP_us=$'\E[01;32m'      # begin underline - green
