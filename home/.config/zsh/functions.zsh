# Utility functions for Zsh
# Ensure Emacs key bindings are used
bindkey -e

# Fix delete key to properly delete characters
bindkey "^[[3~" delete-char

# Create a directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Lazy-load NVM for better startup time
nvm() {
  unset -f nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# Git add, commit and push in one command
gacp() {
  git add .
  git commit -m "$1"
  git push
}

# Copy the last command to clipboard
lastcmd() {
  fc -ln -1 | pbcopy
  echo "Last command copied to clipboard"
}

# Show top memory consuming processes
memhog() {
  ps aux | sort -rn -k 4 | head -${1:-10}
}

# Show top CPU consuming processes
cpuhog() {
  ps aux | sort -rn -k 3 | head -${1:-10}
}

# Kill processes by name
killname() {
  ps aux | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9
}

# HTTP server in current directory
http-server() {
  python3 -m http.server ${1:-8000}
}

# Weather forecast
weather() {
  curl -s "wttr.in/${1:-}"
}

# Create a backup of a file
backup() {
  cp "$1"{,.bak}
}

# Docker utility functions
dockls() {
  docker container ls --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

dockrm() {
  docker container rm -f $(docker container ls -aq)
}
