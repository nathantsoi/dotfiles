#!/bin/bash

# install Vundle bundles
vim +PluginInstall +qall

# build and install YouCompleteMe ext
pushd ~/.vim/bundle/YouCompleteMe
./install.py --tern-completer --clang-completer
popd
