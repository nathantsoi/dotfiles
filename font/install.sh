#!/usr/bin/env bash

set -euo pipefail

FONT_DIR="$(cd "$(dirname "$0")" && pwd)"

case "$(uname -s)" in
  Darwin)
    mkdir -p "$HOME/Library/Fonts"
    cp "$FONT_DIR/Inconsolata-g.ttf" "$HOME/Library/Fonts/"
    if command -v brew >/dev/null 2>&1; then
      brew install --cask font-jetbrains-mono-nerd-font || true
    fi
    ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
        apt-get install -y fonts-powerline fonts-firacode || true
      elif sudo -v >/dev/null 2>&1; then
        sudo apt-get install -y fonts-powerline fonts-firacode || true
      fi
    fi

    mkdir -p "$HOME/.local/share/fonts"
    cp "$FONT_DIR/Inconsolata-g.ttf" "$HOME/.local/share/fonts/"
    command -v fc-cache >/dev/null 2>&1 && fc-cache -f "$HOME/.local/share/fonts" || true
    ;;
esac
