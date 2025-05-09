# Main Zsh configuration file
# This file sources all modules from ~/.config/zsh/

# Modular configuration
ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Set up fzf key bindings and fuzzy completion
if [ -f $(brew --prefix)/opt/fzf/shell/completion.zsh ]; then
  source $(brew --prefix)/opt/fzf/shell/completion.zsh
fi
if [ -f $(brew --prefix)/opt/fzf/shell/key-bindings.zsh ]; then
  source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
fi

# zoxide directory jumper
eval "$(zoxide init zsh)"

# Load modules in the correct order
# Note: 'paths.zsh' has been moved to env/path.zsh and profile/path.zsh
for module in history completions aliases plugins functions; do
  [[ -f "$ZSH_CONFIG_DIR/$module.zsh" ]] && source "$ZSH_CONFIG_DIR/$module.zsh" 
done

# Load custom zoxide interactive feature
[[ -f "$ZSH_CONFIG_DIR/custom_zi.zsh" ]] && source "$ZSH_CONFIG_DIR/custom_zi.zsh"

# Starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# Yazi file manager
export YAZI_CONFIG_HOME="$HOME/.config/yazi/"

# Local customizations (not tracked in git)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
