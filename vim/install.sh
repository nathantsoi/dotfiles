#!/usr/bin/env bash

set -euo pipefail

if ! command -v vim >/dev/null 2>&1; then
  echo "vim is not installed; run script/bootstrap first" >&2
  exit 0
fi

if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  mkdir -p "$HOME/.vim/autoload"
  curl -fLo "$HOME/.vim/autoload/plug.vim" \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +PlugInstall +qall
