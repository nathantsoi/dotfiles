#!/bin/bash

#echo "REBOOT!"

# install vim
UNAMESTR=`uname`
if [ "$UNAMESTR" == 'Darwin' ]; then
  brew install macvim
  brew install the_silver_searcher fzf
else
  sudo apt-get install -y vim silversearcher-ag
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi

# install Plug bundles
vim +PluginInstall +qall

## build and install YouCompleteMe ext
#YCM_PATH=~/.vim/bundle/YouCompleteMe
#pushd $YCM_PATH
#./install.py --tern-completer --clang-completer
#popd

exit 0
