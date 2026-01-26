#!/bin/bash
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

UNAMESTR=`uname`
if [ "$UNAMESTR" != 'Darwin' ]; then
  echo "not on a mac"
  exit
fi

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" > /tmp/homebrew-install.log
fi

# Install homebrew packages
brew install trash
brew install Caskroom/cask/java
brew install cmake git readline sqlite exiftool awscli
brew install aspell --with-all-langs
brew install nvm nodejs rbenv
brew install elasticsearch postgres redis mysql mongo
brew install grc coreutils spark
# gsed
brew install gnu-sed
brew install imagemagick
brew install cowsay fortune
brew install the_silver_searcher
brew install gifsicle
brew install exiv2 ffmpeg

fortune|cowsay

exit 0
