# powerline

#set -xe


# for user installs
if [[ -d "$HOME/.local/pipx/venvs/powerline-status" ]]; then
  POWERLINE_VENV="$HOME/.local/pipx/venvs/powerline-status"
elif [[ -d "$HOME/.local/share/pipx/venvs/powerline-status" ]]; then
  POWERLINE_VENV="$HOME/.local/share/pipx/venvs/powerline-status"
fi

if [[ -n "${POWERLINE_VENV:-}" ]]; then
  POWERLINE_CONFIG_COMMAND="$POWERLINE_VENV/bin/powerline-config"
  POWERLINE_BINDINGS_DIR=$(find "$POWERLINE_VENV" -path "*/site-packages/powerline/bindings" -type d 2>/dev/null | head -n 1)
  export PATH="$POWERLINE_VENV/bin:$PATH"
elif command -v python3 >/dev/null 2>&1; then
  USER_BASE=$(python3 -m site --user-base)
  POWERLINE_CONFIG_COMMAND="${USER_BASE}/bin/powerline-config"
  POWERLINE_BINDINGS_DIR=$(find "$USER_BASE" -path "*/site-packages/powerline/bindings" -type d 2>/dev/null | head -n 1)
  export PATH="${USER_BASE}/bin:$PATH"
fi

if [[ -n "${POWERLINE_BINDINGS_DIR:-}" && -f "$POWERLINE_BINDINGS_DIR/zsh/powerline.zsh" ]]; then
  source "$POWERLINE_BINDINGS_DIR/zsh/powerline.zsh"
  DOTFILES_PROMPT_MODE=powerline-status
elif [[ -z "${DOTFILES_PROMPT_MODE:-}" ]]; then
  DOTFILES_PROMPT_MODE=native-fallback
fi
#source $POWERLINE_BINDINGS_DIR/tmux/powerline.conf
#source $HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim/plugin/powerline.vim
