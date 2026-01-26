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
alias glg='git log --oneline --graph --all --decorate --abbrev-commit'
alias gdf='git log --name-only --oneline'
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
alias gbl="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
# get all branches
#alias gab='git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done'


alias gsupdate='git submodule foreach git pull origin master'

function ggall () {
  git grep "$1" $(git rev-list --all)
}

function gdcol () {
  git difftool "$1" -y -x "colordiff -yd -W $COLUMNS"|less -R
}

function gdifff () {
  git diff-tree --no-commit-id --name-only "$1" -r
}

# required argument, name filter e.g. '*.py' to find and replaces files in this type of file
function whitespace_cleaner () {
  if [ -z "$1" ]; then
    echo "please pass a file filter glob as the first argument. e.g.:\n$0 *.py"
    return
  fi
  find . -iname "$1" -type f -exec sed -i '' 's/[[:space:]]\{1,\}$//' {} \+
}
