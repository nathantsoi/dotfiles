#!/bin/bash

set -o nounset
set -o errexit
#set -o pipefail
set -e

# If we're on a Mac, let's install and setup homebrew.
UNAMESTR=`uname`
if [ "$UNAMESTR" == 'Darwin' ]; then
  brew install pyenv
  brew install pipenv
fi
