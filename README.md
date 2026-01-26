# Dotfiles

## Install

```sh
git clone --recursive git@github.com:your-username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
script/install
```

> [!NOTE]
> The installation scripts detect if you have root access. If not, system package installation (like `zsh`, `vim`, `tmux`) will be skipped, but configuration files will still be linked.

## Customization

Create `~/.dotfiles/zsh/user-config.zsh.local` from `~/.dotfiles/zsh/user-config.zsh` to override variables.

## Updating

```sh
git submodule update --init
```

## Structure

- **bin/**: Executables added to `$PATH`.
- **topic/*.zsh**: Shell configuration.
- **topic/*.symlink**: Symlinked to `~/.topic`.
