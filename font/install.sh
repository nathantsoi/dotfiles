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
        apt-get install -y curl fontconfig fonts-powerline fonts-firacode unzip || true
      elif sudo -n true >/dev/null 2>&1; then
        sudo -n apt-get install -y curl fontconfig fonts-powerline fonts-firacode unzip || true
      fi
    fi

    mkdir -p "$HOME/.local/share/fonts"
    cp "$FONT_DIR/Inconsolata-g.ttf" "$HOME/.local/share/fonts/"
    if command -v curl >/dev/null 2>&1 && command -v unzip >/dev/null 2>&1; then
      nerd_font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
      if ! find "$nerd_font_dir" -name "*JetBrainsMono*Nerd*Font*.ttf" -print -quit 2>/dev/null | grep -q .; then
        tmp_dir="$(mktemp -d)"
        if curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o "$tmp_dir/JetBrainsMono.zip"; then
          mkdir -p "$nerd_font_dir"
          unzip -oq "$tmp_dir/JetBrainsMono.zip" -d "$nerd_font_dir" || true
        fi
        rm -rf "$tmp_dir"
      fi
    fi
    command -v fc-cache >/dev/null 2>&1 && fc-cache -f "$HOME/.local/share/fonts" || true
    ;;
esac
