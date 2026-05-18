#!/usr/bin/env bash

set -euo pipefail

case "$(uname -s)" in
  Darwin)
    if command -v brew >/dev/null 2>&1; then
      brew install tmux reattach-to-user-namespace
    fi
    ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
        apt-get install -y tmux
      elif sudo -v >/dev/null 2>&1; then
        sudo apt-get install -y tmux
      fi
    fi
    ;;
esac
