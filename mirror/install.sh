#!/usr/bin/env bash

set -euo pipefail

case "$(uname -s)" in
  Darwin)
    if command -v brew >/dev/null 2>&1; then
      brew install watchman
    fi
    ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
        apt-get install -y watchman || true
      elif sudo -v >/dev/null 2>&1; then
        sudo apt-get install -y watchman || true
      fi
    fi
    ;;
esac
