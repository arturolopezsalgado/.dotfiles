# ~/.zshenv
# This file is sourced on all shell invocations (login, interactive, scripts)
# Keep this file minimal and only for things needed by all shell types
# Loading Order: The execution order is: .zshenv → .zprofile → .zshrc → .zlogin → .zlogout

# Source modular environment files
ZSH_ENV_DIR="$HOME/.config/zsh/env"

# Source our environment modules
for module in "$ZSH_ENV_DIR"/*.zsh; do
  if [[ -r "$module" ]]; then
    source "$module"
  fi
done

# Load local machine-specific environment if it exists
[[ -f "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"
