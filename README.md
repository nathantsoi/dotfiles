# Dotfiles

Personal dotfiles for macOS and Linux with Zsh, Vim, tmux, Git, fzf, modern CLI tools, Nerd Font icons, and a powerline-status prompt.

## Install

```sh
git clone --recursive git@github.com:nathantsoi/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
script/install
script/doctor
```

Use `script/bootstrap` first. It installs system dependencies, sets up fzf integration, creates dotfile symlinks, and attempts to set Zsh as the login shell. Use `script/install` after bootstrap for topic-specific setup such as Vim plugins and optional language/tool integrations.
Use `script/doctor` after either command to validate the shell, prompt, and installed tools.

If you do not have sudo/root access on Linux, package installation and `chsh` are skipped, but symlinks are still created.

## Supported Systems

- macOS with Homebrew. If Homebrew is missing, `script/bootstrap` installs it.
- Debian/Ubuntu-style Linux with `apt-get`.

Other Linux package managers are not automated yet.

## Installed Tools

`script/bootstrap` installs or attempts to install:

- Shell/editor/session: `zsh`, `vim`, `tmux`, `git`
- Fuzzy search and navigation: `fzf`, `ripgrep`, `fd`, `z`
- Modern CLI tools: `eza` or `exa`, `bat`, `jq`, `yq`, `tree`, `coreutils`, `gnu-sed`, `grc`, `delta`, `gh`, `httpie`, `tldr`/`tlrc`
- System inspection: `duf`, `dust`, `ncdu`, `bottom`, `shellcheck`, `shfmt`
- Environment tools: `direnv`, `pyenv`, `rbenv`, `pipx`, `pipenv`, `uv`, `node`, `npm`, `nvm`, `conda` via Miniforge on macOS
- Media/cloud tools: `imagemagick`, `ffmpeg`, `awscli`, `rclone`, `yt-dlp`, `sqlite`
- File watching: `watchman`
- Prompt/fonts: Powerline-compatible fonts, JetBrains Mono Nerd Font on macOS, and `powerline-status`

On Linux, package names vary by distro version. Optional packages are attempted individually and skipped if unavailable. Bootstrap also normalizes common Ubuntu binary names by linking `fd` to `fdfind` and `bat` to `batcat` in `~/.local/bin` when needed.

For `eza --icons` to render correctly, configure your terminal font to a Nerd Font. On macOS bootstrap installs `JetBrainsMono Nerd Font`; in iTerm2 set your profile font to `JetBrainsMono Nerd Font`.

## Shell Help

After opening a new shell:

```sh
shell-help
shell-help intro
shell-help prompt
shell-help keys
shell-help navigation
shell-help search
shell-help git
shell-help tools
shell-help doctor
script/doctor
```

Aliases:

```sh
zhelp
help-shell
?
```

## Prompt

The prompt uses Python `powerline-status` by default when it is installed. A native Zsh Powerline-style prompt remains as a fallback so shell startup still works if Python tooling is unavailable.

Check the active prompt mode with:

```sh
shell-doctor
```

Customize native fallback colors in `~/.dotfiles/zsh/user-config.zsh.local`:

```zsh
POWERLINE_USER_BG=25
POWERLINE_CWD_BG=240
POWERLINE_GIT_BG=235
```

## Customization

Create local config from the example:

```sh
cp ~/.dotfiles/zsh/user-config.zsh.local.example ~/.dotfiles/zsh/user-config.zsh.local
```

Local config is sourced before the rest of the Zsh setup and is not meant to be committed.

## Updating

```sh
cd ~/.dotfiles
git pull --ff-only
git submodule update --init --recursive
script/bootstrap
script/install
```

## Structure

- `bin/`: executables added to `$PATH`
- `topic/*.zsh`: shell configuration loaded by Zsh
- `topic/*.symlink`: linked to `~/.$name`
- `script/bootstrap`: system dependencies, fzf integration, symlinks, shell setup
- `script/install`: topic-specific installers
