# ~/.zlogin
# Executed for login shells AFTER .zshrc
# Useful for displaying information or starting services at login
# Keep this file minimal and only use for login-specific tasks

# Display system information at login
if [[ -t 0 && -t 1 ]]; then
  # Only show this in interactive terminals

  # Print a welcome message
  print -P "%F{blue}Welcome back, %n!%f"
  print -P "%F{cyan}$(date)%f"

  # System information
  print -P "%F{yellow}System load:    %f$(uptime | awk '{print $3,$4,$5}')"
  print -P "%F{yellow}Memory status:  %f$(vm_stat | grep 'Pages free' | awk '{print $3+$5+$7}' | tr -d '.')/$(vm_stat | grep 'Pages active\|Pages inactive\|Pages speculative\|Pages wired down\|Pages free\|Pages purgeable' | awk '{sum += $3} END {print sum}' | tr -d '.') pages free"
  print
fi

# Load machine-specific login file if it exists
[[ -f "$HOME/.zlogin.local" ]] && source "$HOME/.zlogin.local"
