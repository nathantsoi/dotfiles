#!/bin/bash

if ! type "apt-get" > /dev/null; then
  exit
fi

sudo apt-get -y install \
  cmake \
  silversearcher-ag
