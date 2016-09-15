# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
fi

# The rest of my fun git aliases
alias ga='git add'
alias gl='git log'
alias glp='git log -p'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gpu='git push origin HEAD'
alias gd='git diff'
alias gdc='git diff --cached'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status'
alias gss='git status -sb'
alias gp='git pull'
alias gpr='git pull --rebase'
alias git-sync='git pull --rebase && git push'
alias gt='git log --no-walk --tags --pretty="%h %d %s" --decorate=full'
# show git branches by date modified
alias gbl='for k in `git branch | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r'

alias gsupdate='git submodule foreach git pull origin master'

function ggall () {
  git grep "$1" $(git rev-list --all)
}
