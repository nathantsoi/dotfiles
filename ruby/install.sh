#!/bin/bash

RUBY_GLOBAL_VERSION=3.1.2
UNAMESTR=`uname`
if [ "$UNAMESTR" == 'Darwin' ]; then
  if test ! $(which rbenv)
  then
    echo "  Installing rbenv for you."
    sudo apt-get install -y libreadline-dev
    brew install rbenv > /tmp/rbenv-install.log
  fi

  if test ! $(which ruby-build)
  then
    echo "  Installing ruby-build for you."
    brew install ruby-build > /tmp/ruby-build-install.log
  fi
else
  if test ! $(which rbenv)
  then
    echo "  Installing rbenv for you."
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv > /tmp/rbenv-install.log
  fi

  if test ! $(which ruby-build)
  then
    echo "  Installing ruby-build for you."
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build > /tmp/ruby-build-install.log
  fi
fi

$HOME/.rbenv/bin/rbenv init

if test ! $(rbenv versions | grep $RUBY_GLOBAL_VERSION)
then
  echo "  Installing ruby for you."
  rbenv install $RUBY_GLOBAL_VERSION > /tmp/ruby-install.log
fi

rbenv global $RUBY_GLOBAL_VERSION

gem install bundler >> /tmp/ruby-install.log
rbenv rehash

exit 0
