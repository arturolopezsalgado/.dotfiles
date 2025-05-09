#!/usr/bin/env zsh
# Custom implementation of the "zi" command for interactive directory selection

# Define a custom zi function that uses fzf directly with the zoxide database
custom_zi() {
  local selected_dir
  
  # Use zoxide query with -l to list directories and pipe to fzf
  selected_dir=$(zoxide query -l | fzf --height 40% --reverse --preview 'ls -la {}')
  
  # Change to the selected directory if one was chosen
  if [[ -n "$selected_dir" ]]; then
    cd "$selected_dir"
  fi
}

# Create an alias for the custom zi function
alias zi='custom_zi'
