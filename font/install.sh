#!/bin/sh
#
# Font
#
# This copies fonts into /Library/Fonts

FONT_DIR="$(dirname "$0")"

UNAMESTR=`uname`
if [ "$UNAMESTR" == 'Darwin' ]; then
  cp "$FONT_DIR/Inconsolata-g.ttf" /Library/Fonts/
else
  sudo apt install -y fonts-powerline
fi


exit 0

