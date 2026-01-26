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
  if [ -d "$HOME/.local/share/pipx/venvs/powerline-status" ]; then
    POWERLINE_BINDINGS_DIR=$HOME/.local/share/pipx/venvs/powerline-status/lib/python3.12/site-packages/powerline/bindings
  else
    # Fallback to user site-packages
    USER_BASE=$(python3 -m site --user-base)
    POWERLINE_BINDINGS_DIR=$(find ${USER_BASE} -name "powerline" -type d 2>/dev/null | grep "bindings$" | head -n 1)
  fi
  export PATH=$HOME/.local/bin/:$PATH
fi
if [ -f "$POWERLINE_BINDINGS_DIR/zsh/powerline.zsh" ]; then
  source $POWERLINE_BINDINGS_DIR/zsh/powerline.zsh
fi

if [[ ! -a $HOME/.powerlinebindings && -d "$POWERLINE_BINDINGS_DIR" ]]; then
  ln -s $POWERLINE_BINDINGS_DIR $HOME/.powerlinebindings
fi
#source $POWERLINE_BINDINGS_DIR/tmux/powerline.conf
#source $HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim/plugin/powerline.vim
