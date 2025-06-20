#!/bin/bash

VERSION=2021.07.20.00

set -e
set -x

# install mirror
UNAMESTR=`uname`
if [ "$UNAMESTR" == 'Darwin' ]; then
  brew install watchman
else
  mkdir watchman
  pushd watchman
  wget https://github.com/facebook/watchman/releases/download/v${VERSION}/watchman-v${VERSION}-linux.zip
  unzip watchman-v${VERSION}-linux.zip
  cd watchman-v${VERSION}-linux
  sudo mkdir -p /usr/local/{bin,lib} /usr/local/var/run/watchman
  sudo cp bin/* /usr/local/bin
  sudo cp lib/* /usr/local/lib
  sudo chmod 755 /usr/local/bin/watchman
  sudo chmod 2777 /usr/local/var/run/watchman
  popd
  rm -rf watchman
fi
