#!/bin/sh
#
# Font
#
# This copies fonts into /Library/Fonts

FONT_DIR="$(dirname "$0")"

UNAMESTR=`uname`
if [ "$UNAMESTR" = 'Darwin' ]; then
  cp "$FONT_DIR/Inconsolata-g.ttf" /Library/Fonts/
else
  if [ -w /etc/passwd ] || sudo -v > /dev/null 2>&1; then
    sudo apt install -y fonts-powerline
  fi
fi


exit 0

