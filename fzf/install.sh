#!/usr/bin/env bash

set -euo pipefail

if command -v fzf >/dev/null 2>&1 && fzf --zsh >/dev/null 2>&1; then
  exit 0
fi

if [[ -d "$HOME/.fzf/.git" ]]; then
  git -C "$HOME/.fzf" pull --ff-only || true
else
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi

"$HOME/.fzf/install" --all --no-bash --no-fish
