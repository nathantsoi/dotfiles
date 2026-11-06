#!/usr/bin/env bash

set -euo pipefail

fzf_supports_zsh() {
  local fzf_bin="$1"
  [[ -n "$fzf_bin" && -x "$fzf_bin" ]] && "$fzf_bin" --zsh >/dev/null 2>&1
}

link_checkout_binary() {
  local fzf_bin="$HOME/.fzf/bin/fzf"
  local link="$HOME/.local/bin/fzf"

  fzf_supports_zsh "$fzf_bin" || return 1
  mkdir -p "$HOME/.local/bin"

  # Keep an unrelated, manually installed binary rather than overwriting it.
  # The Zsh integration still prefers ~/.fzf/bin/fzf in that case.
  if [[ -L "$link" || ! -e "$link" ]]; then
    ln -sfn "$fzf_bin" "$link"
  elif [[ "$link" -ef "$fzf_bin" ]]; then
    :
  else
    printf 'warning: leaving existing non-symlink %s in place\n' "$link" >&2
  fi
}

# An existing checkout may have a working binary but no PATH entry (for
# example after copying a home directory). Repair the link before deciding
# that another download is necessary.
if link_checkout_binary; then
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

# Dotfiles owns ~/.zshrc and ~/.fzf.zsh; do not let fzf/install overwrite them.
"$HOME/.fzf/install" --all --no-bash --no-fish --no-update-rc

if ! link_checkout_binary; then
  printf 'error: fzf installation did not produce a Zsh-compatible %s\n' "$HOME/.fzf/bin/fzf" >&2
  exit 1
fi
