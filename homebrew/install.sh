#!/usr/bin/env bash
#
# Homebrew package installation is handled by script/bootstrap.

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed; run script/bootstrap first" >&2
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
