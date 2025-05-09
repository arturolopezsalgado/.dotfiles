# Zsh Completion System Configuration

# Initialize the completion system
autoload -Uz compinit
compinit

# Cache completion to speed it up
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.zcompcache

# Completion options
zstyle ':completion:*' menu select # interactive menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # colored completion
zstyle ':completion:*' verbose true # verbose completion messages
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f' # descriptions format
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f' # corrections format
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f' # messages format
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f' # warning format
zstyle ':completion:*:default' list-prompt '%S%M matches%s' # match prompt

# Group matches and describe
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# Process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# Ignore some files and directories from completion
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

# SSH host completion
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Kubectl completion
if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi

# Complete aliases
setopt complete_aliases

# Complete dots (e.g. cd ../<TAB>)
zstyle ':completion:*' special-dirs true
