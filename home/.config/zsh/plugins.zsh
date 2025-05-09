# Zsh plugins configuration

# Set up zplug
export ZPLUG_HOME="$(brew --prefix zplug)"
source "$ZPLUG_HOME/init.zsh"

# Define plugins
zplug "zsh-users/zsh-autosuggestions"
zplug "MichaelAquilina/zsh-you-should-use"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "mafredri/zsh-async"

# Plugin configuration
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
YSU_MESSAGE_FORMAT="Found existing %alias_type for '%command': %alias"

# Install plugins if not already installed
if ! zplug check --verbose; then
    zplug install
fi

# Load plugins
zplug load
