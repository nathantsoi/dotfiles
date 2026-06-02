#!/usr/bin/env bash
#
# Debian/Ubuntu package installation is handled by script/setup.

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

apt_install_one() {
  apt_install install -y "$1" || true
}

apt_install update

for package in \
  bash build-essential ca-certificates cmake curl fontconfig fonts-firacode \
  fonts-powerline fzf git jq pipx python3 python3-pip python3-venv ripgrep \
  tmux tree unzip vim zsh; do
  apt_install_one "$package"
done

for package in \
  bat bottom direnv duf dust eza exa fd-find ffmpeg gh git-delta httpie \
  imagemagick ncdu nodejs npm postgresql-client rclone shellcheck shfmt \
  silversearcher-ag sqlite3 tldr uv watchman yq yt-dlp; do
  apt_install_one "$package"
done

mkdir -p "$HOME/.local/bin"
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
fi
