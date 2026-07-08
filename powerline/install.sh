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

  # Stale regular files (e.g. an old hand-compiled ELF client or pip --user
  # scripts) at ~/.local/bin/powerline* block pipx from symlinking its venv
  # binaries ("points to itself / Not modifying"). Remove the non-symlink
  # ones so pipx can install clean symlinks. pipx-managed symlinks are left
  # alone.
  for tool in powerline powerline-config powerline-daemon powerline-lint powerline-render; do
    target="$HOME/.local/bin/$tool"
    if [[ -e "$target" && ! -L "$target" ]]; then
      rm -f "$target"
    fi
  done

  if pipx list --short 2>/dev/null | grep -Eq "^powerline-status([[:space:]]|$)"; then
    :
  elif [[ -n "$powerline_python" ]]; then
    pipx install powerline-status --python "$powerline_python" || true
  else
    pipx install powerline-status || true
  fi
  pipx inject powerline-status powerline-gitstatus >/dev/null 2>&1 || true

  # pipx only (re)creates the ~/.local/bin app symlinks during `pipx install`,
  # so an already-installed package left without symlinks (e.g. after we
  # removed stale blocking files above) never gets them back. Recreate them
  # pointing at the venv binaries, matching pipx's own layout.
  venv_bin=""
  for candidate in "$HOME/.local/share/pipx/venvs/powerline-status/bin" \
                   "$HOME/.local/pipx/venvs/powerline-status/bin"; do
    if [[ -d "$candidate" ]]; then
      venv_bin="$candidate"
      break
    fi
  done
  if [[ -n "$venv_bin" ]]; then
    mkdir -p "$HOME/.local/bin"
    for tool in powerline powerline-config powerline-daemon powerline-lint powerline-render; do
      if [[ -x "$venv_bin/$tool" ]]; then
        ln -sfn "$venv_bin/$tool" "$HOME/.local/bin/$tool"
      fi
    done
  fi
elif command -v pip3 >/dev/null 2>&1; then
  # PEP 668 (Ubuntu 24.04+) blocks plain `pip install --user` with
  # externally-managed-environment. Fall back to --break-system-packages, which
  # still targets the user site (~/.local) and never touches system packages.
  # Powerline is pure Python, so a user install is safe.
  pip3 install --user powerline-status powerline-gitstatus 2>/dev/null \
    || pip3 install --user --break-system-packages powerline-status powerline-gitstatus || true
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
  # powerline-status 2.7 ships a non-raw regex literal in bindings/config.py
  # (`re.compile('\$(_POWERLINE_\w+)')`). Python 3.12 raises a SyntaxWarning
  # for the invalid `\$` string escape at import time, which prints on every
  # shell start since paths.zsh sources the binding. Convert it to a raw
  # string. Idempotent: a no-op once already patched.
  config_py="$POWERLINE_BINDINGS_DIR/config.py"
  if [[ -f "$config_py" ]] && grep -q "TMUX_VAR_RE = re\.compile('" "$config_py"; then
    sed -i "/TMUX_VAR_RE = re\.compile(/ s/re\.compile('/re.compile(r'/" "$config_py"
  fi
fi
