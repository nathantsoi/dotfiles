#!/usr/bin/env bash

UNAMESTR=`uname`
if [[ "$UNAMESTR" != 'Darwin' ]]; then
  alias mvim="gvim"
fi
