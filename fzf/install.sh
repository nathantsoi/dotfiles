#!/usr/bin/env bash

set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fzf_supports_zsh() {
  local fzf_bin="$1"
  [[ -n "$fzf_bin" && -x "$fzf_bin" ]] && "$fzf_bin" --zsh >/dev/null 2>&1
}

if [[ -x "$HOME/.fzf/bin/fzf" ]] && fzf_supports_zsh "$HOME/.fzf/bin/fzf"; then
  exit 0
fi

if command -v fzf >/dev/null 2>&1 && fzf_supports_zsh "$(command -v fzf)"; then
  exit 0
fi

if [[ -d "$HOME/.fzf/.git" ]]; then
  git -C "$HOME/.fzf" pull --ff-only || true
else
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi

"$HOME/.fzf/install" --all --no-bash --no-fish --no-update-rc
