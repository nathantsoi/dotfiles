shell-help() {
  local topic="${1:-overview}"

  case "$topic" in
    overview|help)
      command cat <<'EOF'
Dotfiles shell help

Usage:
  shell-help                 Show this overview
  shell-help intro           Walk through the daily shell workflow
  shell-help prompt          Explain the prompt
  shell-help keys            Show keybindings
  shell-help navigation      Directory movement and jumping
  shell-help search          Search, fzf, and file opening
  shell-help git             Git shortcuts and prompt symbols
  shell-help tools           Modern CLI tool aliases
  shell-help doctor          Check optional tools

Fast start:
  shell-help intro           Start here for a guided walkthrough
  reload!                    Reload ~/.zshrc
  j <partial-dir>            Jump with z's frecency database
  cdf                        Fuzzy cd into a directory
  ff                         Fuzzy-open a file in $EDITOR
  rg <text>                  Search file contents
  gss                        Short git status
  groot                      cd to the current git repo root
EOF
      ;;
    intro|tutorial|walkthrough)
      command cat <<'EOF'
Shell walkthrough

1. Read the prompt
   Left side shows user, current directory, and git state.
   Right side shows failures, active environments, and time.
   Run shell-help prompt for the full symbol key.

2. Move around quickly
   j src                     jump to a frequently used path matching src
   cdf                       fuzzy-select a directory and cd into it
   up 2                      move two directories up
   groot                     jump to the current git repository root

3. Find files and text
   ff                        fuzzy-open a file in $EDITOR
   rg TODO                   search file contents
   ffind '*.zsh'             find files by name with fd/fdfind
   fh                        fuzzy-search command history

4. Inspect output
   ls / ll / la              eza/exa listings with directory grouping and icons
   tree                      compact directory tree
   b README.md               syntax-highlight a file with bat/batcat
   c README.md               print highlighted file content without paging

5. Work in git
   gss                       short status
   gd                        unstaged diff
   gdc                       staged diff
   glg                       compact graph
   gpr                       pull with rebase
   gpu                       push current HEAD
   git-sync                  pull --rebase then push

6. Manage project environments
   direnv allow              trust a project .envrc
   pyenv versions            list Python versions
   rbenv versions            list Ruby versions
   uv --help                 fast Python package/project tooling
   pipx list                 installed isolated Python CLIs

7. Check the setup
   shell-doctor              show installed tools and prompt mode
   shell-help tools          see the tool map
EOF
      ;;
    prompt)
      command cat <<'EOF'
Prompt

The prompt uses Python powerline-status by default when it is installed.
A native Zsh Powerline-style prompt is kept as the fallback so startup still works
if Python or powerline-status is temporarily unavailable.

Segments:
  user                       Local user, or user@host over SSH
  cwd                        Current directory
  git:<branch>               Current branch or short SHA
  *                          Dirty git worktree
  ↑ / ↓                      Branch is ahead / behind upstream
  right prompt               Last non-zero exit code, env hints, time

Native fallback colors can be overridden in zsh/user-config.zsh.local:
  POWERLINE_USER_BG=25
  POWERLINE_CWD_BG=240
  POWERLINE_GIT_BG=235

Check the active prompt mode:
  shell-doctor
EOF
      ;;
    keys)
      command cat <<'EOF'
Keybindings

  Up / Down                  Prefix history search
  Ctrl-R                     fzf history search, native reverse search fallback
  Ctrl-X Ctrl-E              Edit the current command in $EDITOR
  Option-Left / Option-Right Move by word
  Delete                     Delete character under cursor
  Option-Cmd-N               Open a new terminal tab via local newtab widget

fzf bindings are loaded from ~/.fzf.zsh in real terminal sessions when available.
EOF
      ;;
    navigation)
      command cat <<'EOF'
Navigation

  .. / ... / ....            cd up 1 / 2 / 3 levels
  -                          cd to previous directory
  up [n]                     cd up n levels
  mkcd <dir>                 mkdir -p and cd into it
  take <dir>                 alias-style wrapper for mkcd
  j <query>                  jump using z frecency
  cdf                        fuzzy-select a directory and cd into it
  groot                      cd to git repo root
  path                       print PATH one entry per line
EOF
      ;;
    search)
      command cat <<'EOF'
Search and fuzzy finding

  rg <text>                  fast recursive content search
  rgrep <text>               explicit ripgrep alias
  ffind <name>               fd shortcut when fd is installed
  ff                         fuzzy-select a file and open it in $EDITOR
  fh                         fuzzy-select a command from history and print it
  cdf                        fuzzy-select a directory and cd into it

fzf uses fd when available, otherwise rg --files.
EOF
      ;;
    git)
      command cat <<'EOF'
Git

  gss                        git status -sb
  gs                         git status
  gd / gdc                   git diff / cached diff
  ga                         git add
  gc                         git commit
  gco                        git checkout
  glg                        compact decorated graph
  glog                       detailed decorated graph
  gpu                        push current HEAD to origin
  gpr                        pull --rebase
  git-sync                   pull --rebase then push
  groot                      cd to current repo root

Prompt git symbols:
  *                          uncommitted changes
  ↑                          ahead of upstream
  ↓                          behind upstream
EOF
      ;;
    tools)
      command cat <<'EOF'
Modern CLI integrations

  eza/exa                    used for ls/l/ll/la/tree when installed
  bat                        b and c aliases when installed
  rg                         content search and fzf file source fallback
  fd                         ffind alias and preferred fzf file source
  fzf                        fuzzy directory/file/history workflows
  z                          frecency directory jumping via j
  ag                         classic Silver Searcher fallback/search tool
  delta                      nicer git diff pager when configured
  gh                         GitHub CLI
  jq/yq                      JSON/YAML processors
  http                       HTTP client from httpie
  tldr/tlrc                  short practical command examples
  duf/dust/ncdu              disk usage inspection
  btm                        terminal process/system monitor
  shellcheck/shfmt           shell script linting and formatting
  uv/pipx/pipenv             Python project and CLI tooling
  node/npm/nvm               JavaScript runtime and version tooling
  magick/ffmpeg              image and media tools
  aws/rclone/yt-dlp          cloud, sync, and download utilities
  colored-man-pages          nicer man page colors
  direnv                     auto-loaded when installed
  pyenv/rbenv                initialized without startup rehash
EOF
      ;;
    doctor)
      shell-doctor
      ;;
    *)
      print -r -- "Unknown topic: $topic"
      print -r -- "Try: shell-help overview intro prompt keys navigation search git tools doctor"
      return 1
      ;;
  esac
}

_doctor_one() {
  local label="$1"
  local command_name="$2"

  if command -v "$command_name" >/dev/null 2>&1; then
    local location="${commands[$command_name]:-$(command -v "$command_name")}"
    print -r -- "  ok   $label -> $location"
  else
    print -r -- "  miss $label"
  fi
}

_doctor_any() {
  local label="$1"
  shift

  local command_name
  for command_name in "$@"; do
    if command -v "$command_name" >/dev/null 2>&1; then
      local location="${commands[$command_name]:-$(command -v "$command_name")}"
      print -r -- "  ok   $label -> $location ($command_name)"
      return
    fi
  done

  print -r -- "  miss $label"
}

shell-doctor() {
  local tool
  command cat <<'EOF'
Shell doctor

Required:
EOF
  _doctor_one zsh zsh
  _doctor_one git git
  _doctor_one vim vim

  command cat <<'EOF'

Optional power tools:
EOF
  _doctor_one fzf fzf
  _doctor_one rg rg
  _doctor_any fd/fdfind fd fdfind
  _doctor_any eza/exa eza exa
  _doctor_any bat/batcat bat batcat
  _doctor_one ag ag
  _doctor_one delta delta
  _doctor_one gh gh
  _doctor_one jq jq
  _doctor_one yq yq
  _doctor_one http http
  _doctor_any tldr/tlrc tldr tlrc
  _doctor_one duf duf
  _doctor_one dust dust
  _doctor_one ncdu ncdu
  _doctor_one btm btm
  _doctor_one shellcheck shellcheck
  _doctor_one shfmt shfmt
  _doctor_one direnv direnv
  _doctor_one pyenv pyenv
  _doctor_one rbenv rbenv
  _doctor_one uv uv
  _doctor_one pipx pipx
  _doctor_one pipenv pipenv
  _doctor_one node node
  _doctor_one npm npm
  _doctor_one nvm nvm
  _doctor_one magick magick
  _doctor_one ffmpeg ffmpeg
  _doctor_one aws aws
  _doctor_one rclone rclone
  _doctor_one yt-dlp yt-dlp
  _doctor_one watchman watchman
  _doctor_one sqlite3 sqlite3
  _doctor_one psql psql
  _doctor_one conda conda
  _doctor_one pixi pixi

  command cat <<'EOF'

Powerline:
EOF
  for tool in powerline powerline-render powerline-config powerline-daemon; do
    if command -v "$tool" >/dev/null 2>&1; then
      print -r -- "  ok   $tool -> ${commands[$tool]}"
    else
      print -r -- "  miss $tool"
    fi
  done

  if command -v powerline-render >/dev/null 2>&1 && powerline-render shell left --width 40 >/dev/null 2>&1; then
    print -r -- "  ok   powerline-render shell"
  else
    print -r -- "  miss powerline-render shell"
  fi

  command cat <<'EOF'

Prompt:
EOF
  if [[ "${DOTFILES_PROMPT_MODE:-}" == "powerline-status" ]]; then
    print -r -- "  ok   Python powerline-status prompt is active"
  else
    print -r -- "  warn native Powerline-style fallback prompt is active"
  fi
}

alias zhelp='shell-help'
alias help-shell='shell-help'
alias '?'='shell-help'
