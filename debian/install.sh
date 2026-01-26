#!/bin/bash

if ! type "apt-get" > /dev/null; then
  exit
fi

if [ -w /etc/passwd ] || sudo -v > /dev/null 2>&1; then
  sudo apt-get -y install \
    cmake \
    silversearcher-ag
fi
