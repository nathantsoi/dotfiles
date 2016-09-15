#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" > /tmp/homebrew-install.log
fi

# Install homebrew packages
brew install trash
brew install Caskroom/cask/java
brew install git readline sqlite exiftool awscli
brew install aspell --with-all-langs
brew install python nodejs rbenv
brew install elasticsearch postgres redis mysql mongo
brew install grc coreutils spark
brew install imagemagick
brew install cowsay fortune
brew install the_silver_searcher

fortune|cowsay

exit 0
