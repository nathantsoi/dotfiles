#!/usr/bin/env bash

set -euo pipefail

case "$(uname -s)" in
  Darwin)
    if command -v brew >/dev/null 2>&1; then
      brew install rbenv ruby-build
    fi
    ;;
  Linux)
    if command -v rbenv >/dev/null 2>&1; then
      exit 0
    fi

    git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv" || true
    mkdir -p "$HOME/.rbenv/plugins"
    git clone https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build" || true
    ;;
esac
