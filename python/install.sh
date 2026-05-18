#!/usr/bin/env bash

set -euo pipefail

case "$(uname -s)" in
  Darwin)
    if command -v brew >/dev/null 2>&1; then
      brew install pyenv pipenv pipx
    fi
    ;;
  Linux)
    if command -v pyenv >/dev/null 2>&1; then
      exit 0
    fi

    if command -v curl >/dev/null 2>&1; then
      curl -fsSL https://pyenv.run | bash || true
    fi
    ;;
esac
