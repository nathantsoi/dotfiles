autoload -U colors && colors

setopt PROMPT_SUBST

POWERLINE_LEFT_SEPARATOR=$'\ue0b0'

# Native Powerline-style fallback. powerline/paths.zsh loads Python
# powerline-status later and overrides this prompt when available.
POWERLINE_USER_BG=${POWERLINE_USER_BG:-25}
POWERLINE_USER_FG=${POWERLINE_USER_FG:-white}
POWERLINE_CWD_BG=${POWERLINE_CWD_BG:-240}
POWERLINE_CWD_FG=${POWERLINE_CWD_FG:-white}
POWERLINE_GIT_BG=${POWERLINE_GIT_BG:-235}
POWERLINE_GIT_FG=${POWERLINE_GIT_FG:-250}

_prompt_text() {
  print -P -- "$1"
}

_prompt_segment() {
  local bg="$1"
  local fg="$2"
  local text="$3"

  [[ -z "$text" ]] && return
  print -n "%K{$bg}%F{$fg} ${text} %k%F{$bg}${POWERLINE_LEFT_SEPARATOR}%f"
}

_prompt_identity() {
  if [[ -n "$SSH_CONNECTION" ]]; then
    _prompt_text "%n@%m"
  else
    _prompt_text "%n"
  fi
}

_prompt_git_branch() {
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  local branch dirty ahead behind git_status
  branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null)
  [[ -n "$branch" ]] || branch=$(command git rev-parse --short HEAD 2>/dev/null)
  [[ -n "$branch" ]] || return

  git_status=$(command git status --porcelain=v1 --branch 2>/dev/null)
  [[ "$git_status" == *$'\n'* ]] && dirty=" *"

  if [[ "$git_status" == '## '*"ahead "* ]]; then
    ahead=" ↑"
  fi
  if [[ "$git_status" == '## '*"behind "* ]]; then
    behind=" ↓"
  fi

  print -r -- "git:${branch}${dirty}${ahead}${behind}"
}

_prompt_left() {
  _prompt_segment "$POWERLINE_USER_BG" "$POWERLINE_USER_FG" "$(_prompt_identity)"
  _prompt_segment "$POWERLINE_CWD_BG" "$POWERLINE_CWD_FG" "%~"
  _prompt_segment "$POWERLINE_GIT_BG" "$POWERLINE_GIT_FG" "$(_prompt_git_branch)"
  print -n " "
}

_prompt_exit_status() {
  local exit_code="$1"
  (( exit_code == 0 )) && return
  print -n "%F{red}${exit_code}%f "
}

_prompt_runtime() {
  local parts=()

  [[ -n "$CONDA_DEFAULT_ENV" ]] && parts+=("conda:$CONDA_DEFAULT_ENV")
  [[ -n "$VIRTUAL_ENV" ]] && parts+=("venv:${VIRTUAL_ENV:t}")
  [[ -n "$AWS_PROFILE" ]] && parts+=("aws:$AWS_PROFILE")
  [[ -n "$KUBECONFIG" ]] && parts+=("kube")

  (( ${#parts} )) && print -n "%F{244}${(j: :)parts}%f "
}

_prompt_right() {
  local last_status="$?"
  _prompt_exit_status "$last_status"
  _prompt_runtime
  print -n "%F{244}%D{%H:%M}%f"
}

PROMPT='$(_prompt_left)'
RPROMPT='$(_prompt_right)'
DOTFILES_PROMPT_MODE=native-fallback

precmd() {
  title "zsh" "%m" "%55<...<%~"
}
