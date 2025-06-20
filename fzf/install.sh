#!/bin/bash

UNAMESTR=`uname`
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || 1
~/.fzf/install

exit 0
