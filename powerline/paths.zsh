# powerline

#set -xe


# for user installs
UNAMESTR=$(uname)
if [[ "$UNAMESTR" == 'Darwin' ]]; then
  # Use user-installed powerline instead of pipx
  USER_BASE=$(python3 -m site --user-base)
  POWERLINE_CONFIG_COMMAND="${USER_BASE}/bin/powerline-config"
  POWERLINE_BINDINGS_DIR=${USER_BASE}/lib/python/site-packages/powerline/bindings
  export PATH=${USER_BASE}/bin:$PATH
else
  # user install
  POWERLINE_BINDINGS_DIR=$(python3 -m site --user-site)/powerline/bindings
  export PATH=$HOME/.local/bin/:$PATH
fi
source $POWERLINE_BINDINGS_DIR/zsh/powerline.zsh

if [[ ! -a $POWERLINE_BINDINGS_DIR ]]; then
  ln -s $POWERLINE_BINDINGS_DIR $HOME/.powerlinebindings
fi
#source $POWERLINE_BINDINGS_DIR/tmux/powerline.conf
#source $HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim/plugin/powerline.vim
