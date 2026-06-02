#!/usr/bin/env bash

set -euo pipefail

if ! command -v vim >/dev/null 2>&1; then
  echo "vim is not installed; run script/setup first" >&2
  exit 0
fi

if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  mkdir -p "$HOME/.vim/autoload"
  curl -fLo "$HOME/.vim/autoload/plug.vim" \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# PlugInstall paints a full-screen UI. Without a TTY, vim still writes cursor
# motion and redraw escapes to stdout and breaks the calling terminal layout.
vim '+PlugInstall --sync' +qall! </dev/null >/dev/null
