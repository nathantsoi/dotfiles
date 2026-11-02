#!/usr/bin/env bash
#
# Homebrew package installation. Shared-prefix aware: when the Homebrew prefix
# is owned by another user, brew runs via `sudo -n -H -u <owner>` and the
# prefix's permissions are never changed (see script/brew.lib).

set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  exit 0
fi

# shellcheck source=../script/brew.lib
source "$DOTFILES_ROOT/script/brew.lib"

if ! setup_brew; then
  echo "Homebrew is not usable (not installed, root-owned prefix, or a shared prefix without sudo); run script/setup first" >&2
  exit 0
fi

packages=(
  awscli
  bat
  bottom
  cmake
  coreutils
  direnv
  duf
  dust
  eza
  fd
  ffmpeg
  fzf
  gh
  git
  git-delta
  gnu-sed
  grc
  httpie
  imagemagick
  jq
  ncdu
  node
  nvm
  pipx
  pipenv
  python@3.13
  pyenv
  rclone
  rbenv
  ripgrep
  shellcheck
  shfmt
  sqlite
  the_silver_searcher
  tlrc
  tmux
  tree
  uv
  watchman
  yq
  yt-dlp
  zsh
)

missing=()
for package in "${packages[@]}"; do
  if ! brew list --formula "$package" >/dev/null 2>&1; then
    missing+=("$package")
  fi
done

if ! brew list --formula vim >/dev/null 2>&1 && ! brew list --formula macvim >/dev/null 2>&1; then
  missing+=(vim)
fi

if (( ${#missing[@]} )); then
  brew install "${missing[@]}"
fi

for cask in font-inconsolata font-jetbrains-mono-nerd-font miniforge; do
  if ! brew list --cask "$cask" >/dev/null 2>&1; then
    brew install --cask "$cask" || true
  fi
done
