#!/bin/sh

if test ! $(which rbenv)
then
  echo "  Installing rbenv for you."
  brew install rbenv > /tmp/rbenv-install.log
fi

if test ! $(which ruby-build)
then
  echo "  Installing ruby-build for you."
  brew install ruby-build > /tmp/ruby-build-install.log
fi

if test ! $(which ruby)
then
  echo "  Installing ruby for you."
  rbenv install 2.3.0 > /tmp/ruby-install.log
  gem install bundler >> /tmp/ruby-install.log
  gem install lolcat >> /tmp/ruby-install.log
  rbenv rehash
fi
