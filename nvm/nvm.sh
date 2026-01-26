#!/usr/bin/env bash

export NVM_DIR="$HOME/.nvm"
UNAMESTR=`uname`
if [[ "$UNAMESTR" == 'Darwin' ]]; then
  . "/usr/local/opt/nvm/nvm.sh"
else
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi
