#!/bin/bash
DEST=$HOME/Downloads/inconsolata-powerline.otf
curl https://github.com/powerline/fonts/blob/master/Inconsolata-g/Inconsolata-g%20for%20Powerline.otf?raw=true -o $DEST
#open $DEST

UNAMESTR=`uname`
if [ "$UNAMESTR" == 'Darwin' ]; then
  # Install powerline-status using pip3 --user so it's accessible to vim's python
  # Use --break-system-packages for modern macOS Python environments
  pip3 install --user --break-system-packages powerline-status
  pip3 install --user --break-system-packages powerline-gitstatus
else
  sudo apt install -y python3-pip
  pip3 install --user powerline-status
  pip3 install --user powerline-gitstatus
fi

CONFIGDIR=$HOME/.config
mkdir -p $CONFIGDIR
ln -sf $HOME/.dotfiles/powerline/config/powerline.symlink $CONFIGDIR/powerline
