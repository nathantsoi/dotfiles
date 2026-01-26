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
  if [ -w /etc/passwd ] || sudo -v > /dev/null 2>&1; then
    sudo apt install -y pipx
  else
    echo "  Skipping pipx system installation (no root access)"
  fi
  
  if command -v pipx >/dev/null 2>&1; then
      pipx install powerline-status
      pipx inject powerline-status powerline-gitstatus
  else
      # Fallback to user install if pipx is not available
      pip3 install --user powerline-status powerline-gitstatus
  fi
fi

CONFIGDIR=$HOME/.config
mkdir -p $CONFIGDIR
ln -sf $HOME/.local/share/pipx/venvs/powerline-status/lib/python3.12/site-packages/powerline/config/powerline.symlink $CONFIGDIR/powerline
