# directories
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias md='mkdir -p'
alias rd='rmdir'
alias dapps="cd /Applications"
alias ddev="cd $HOME/dev"
alias ddoc="cd $HOME/Documents"
alias ddow="cd $HOME/Downloads"

# convinience
alias cat=/usr/local/bin/bat
alias egrep='grep -E'
alias fgrep='grep -F'
# alias cd='z' # Removed - causes issues with zoxide's normal functionality
alias y='yazi'

# eza
alias ls='eza --no-user --icons --group-directories-first'
alias ll='eza --no-user --icons --group-directories-first --git -oh -l'
alias la='eza --no-user --icons --group-directories-first --git -oh -la'
alias lt='eza --no-user --icons --group-directories-first --git -oh --tree --level=2 -l'
alias lt3='eza --no-user --icons --group-directories-first --git -oh --tree --level=3 -l'
alias l.="eza -a | grep -E '^\.'"

# git
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gau='git add --update'
alias gav='git add --verbose'
alias gb='git branch'
alias gbd='git branch -D'
alias gba='git branch --all'
alias gbr='git branch --remote'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gclean='git clean --interactive -d'
alias gc='git commit --message'
alias gca='git commit --verbose --all'
alias gcam='git commit --all --message'
alias gammend='git commit --amend --no-edit --no-verify'
alias gf='git fetch'
alias gfo='git fetch origin'
alias glo='git log --oneline'
alias glog='git log --graph --decorate --all'
alias ggrep='git ls-files | grep'
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gmff='git merge --ff-only'
alias gms='git merge --squash'
alias gl='git pull'
alias gplr='git pull --rebase'
alias gplf='git pull --ff-only'
alias gp='git push'
alias gpd='git push --dry-run'
alias gs='git status'
alias gss='git status --short'
alias gsw='git switch'
alias gswc='git switch -c'
alias gcd='git switch develop'
alias gcm='git switch main'
alias gcn='git switch nprd'
alias glprune='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}"'
alias gprune='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -d'
alias gprunedry='git remote prune --dry-run origin'
alias gpruneo='git remote prune origin'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'
alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grev='git revert'
alias greva='git revert --abort'
alias grevc='git revert --continue'
alias grs='git reset'
alias grsh='git reset --hard'
alias grsk='git reset --keep'
alias grss='git reset --soft'
alias gsh='git show'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gwipe='git reset --hard && git clean --force -df'
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtmv='git worktree move'
alias gwtrm='git worktree remove'

# K8S
alias k="kubectl"
alias ka="kubectl apply -f"
alias kg="kubectl get"
alias kd="kubectl describe"
alias kdel="kubectl delete"
alias kl="kubectl logs"
alias kgpo="kubectl get pod"
alias kgd="kubectl get deployments"
alias kc="kubectx"
alias kns="kubens"
alias kl="kubectl logs -f"
alias ke="kubectl exec -it"
alias kcns='kubectl config set-context --current --namespace'
