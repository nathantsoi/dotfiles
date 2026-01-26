#!/bin/bash

# https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard

UNAMESTR=$(uname)
if [ "$UNAMESTR" == 'Darwin' ]; then
  brew install reattach-to-user-namespace
else
  if [ -w /etc/passwd ] || sudo -v > /dev/null 2>&1; then
    sudo apt install -y tmux
  else
    echo "  Skipping tmux installation (no root access)"
  fi
fi
