#!/usr/bin/env bash

set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if command -v pipx >/dev/null 2>&1; then
  pipx ensurepath --force >/dev/null 2>&1 || true
  powerline_python=""
  if command -v python3.13 >/dev/null 2>&1; then
    powerline_python="$(command -v python3.13)"
  elif command -v python3.12 >/dev/null 2>&1; then
    powerline_python="$(command -v python3.12)"
  elif command -v python3 >/dev/null 2>&1; then
    powerline_python="$(command -v python3)"
  fi

  if pipx list --short 2>/dev/null | grep -Eq "^powerline-status([[:space:]]|$)"; then
    :
  elif [[ -n "$powerline_python" ]]; then
    pipx install powerline-status --python "$powerline_python" || true
  else
    pipx install powerline-status || true
  fi
  pipx inject powerline-status powerline-gitstatus >/dev/null 2>&1 || true
elif command -v pip3 >/dev/null 2>&1; then
  pip3 install --user powerline-status powerline-gitstatus || true
fi

CONFIGDIR="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$CONFIGDIR"
if [[ -L "$CONFIGDIR/powerline" || ! -e "$CONFIGDIR/powerline" ]]; then
  ln -sfn "$DOTFILES_ROOT/powerline/config/powerline.symlink" "$CONFIGDIR/powerline"
elif [[ -d "$CONFIGDIR/powerline" ]]; then
  echo "Existing Powerline config directory left in place: $CONFIGDIR/powerline" >&2
fi

if [[ -n "${POWERLINE_BINDINGS_DIR:-}" ]]; then
  :
elif [[ -d "$HOME/.local/pipx/venvs/powerline-status/lib" ]]; then
  POWERLINE_BINDINGS_DIR=$(find "$HOME/.local/pipx/venvs/powerline-status/lib" -path "*/site-packages/powerline/bindings" -type d 2>/dev/null | head -n 1)
elif [[ -d "$HOME/.local/share/pipx/venvs/powerline-status/lib" ]]; then
  POWERLINE_BINDINGS_DIR=$(find "$HOME/.local/share/pipx/venvs/powerline-status/lib" -path "*/site-packages/powerline/bindings" -type d 2>/dev/null | head -n 1)
fi

if [[ -n "${POWERLINE_BINDINGS_DIR:-}" ]]; then
  ln -sfn "$POWERLINE_BINDINGS_DIR" "$HOME/.powerlinebindings"
fi
