#!/usr/bin/env bash
#
# Debian/Ubuntu package installation is handled by script/bootstrap.

set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  exit 0
fi

if [[ ${EUID:-$(id -u)} -ne 0 ]] && ! sudo -v >/dev/null 2>&1; then
  echo "Skipping apt installs; no sudo/root access"
  exit 0
fi

apt_install() {
  if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    apt-get "$@"
  else
    sudo apt-get "$@"
  fi
}

apt_install update
apt_install install -y \
  bash \
  build-essential \
  cmake \
  curl \
  fonts-firacode \
  fonts-powerline \
  fzf \
  git \
  httpie \
  imagemagick \
  jq \
  ncdu \
  nodejs \
  npm \
  pipx \
  python3 \
  python3-pip \
  python3-venv \
  ripgrep \
  shellcheck \
  shfmt \
  silversearcher-ag \
  sqlite3 \
  tmux \
  tree \
  vim \
  zsh

for package in bat bottom direnv duf dust eza exa fd-find ffmpeg gh git-delta postgresql-client rclone tldr uv watchman yq yt-dlp; do
  apt_install install -y "$package" || true
done
