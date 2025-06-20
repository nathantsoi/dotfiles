#!/bin/bash

# https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard

UNAMESTR=$(uname)
if [ "$UNAMESTR" == 'Darwin' ]; then
  brew install reattach-to-user-namespace
else
  sudo apt install -y tmux
fi
