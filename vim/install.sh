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

# PlugInstall paints a full-screen UI. Run vim in silent batch ex mode (-es)
# with all fds detached so it can't emit cursor-motion/redraw escapes (or the
# "Input is not from a terminal" warning) to the tty — those scramble the
# calling terminal's layout and interleave setup's later output on screen.
vim -es '+PlugInstall --sync' '+qall!' </dev/null >/dev/null 2>&1 || true
