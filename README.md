# Dotfiles

Personal dotfiles for macOS and Linux with Zsh, Vim, tmux, Git, fzf, modern CLI tools, Nerd Font icons, and a powerline-status prompt.

## Install

```sh
git clone --recursive git@github.com:nathantsoi/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
sudo -v   # optional but recommended when available
script/setup
script/doctor
```

`sudo -v` is **optional**. With cached sudo credentials, setup installs system packages via apt/Homebrew and changes your login shell. **Without sudo** (e.g. on a shared server or container), setup still completes: it installs what it can user-locally (fzf, nvm, Miniforge, pyenv, rbenv, Nerd Font, pipx/powerline, and a set of static binaries from GitHub releases into `~/.local/bin`) and records everything it couldn't install in a **deferred-items** report printed at the end of the run and by `script/doctor` / `shell-doctor`, each with a remediation hint.

Without sudo, setup also makes Zsh the effective shell: it installs zsh into the Miniforge base env (linked at `~/.local/bin/zsh`), and—since `chsh` requires root and an `/etc/shells` entry it can't edit—appends a guarded `exec zsh` to `~/.bashrc` and `~/.bash_profile` so interactive sessions drop into Zsh. `$SHELL` still reports bash (cosmetic); to make it the real login shell later, add the zsh path to `/etc/shells` and run `chsh -s <zsh>` once you have root.

`script/setup` installs system dependencies, sets up fzf integration, creates dotfile symlinks, runs topic-specific installers (Vim plugins, and similar), and attempts to set Zsh as the login shell.

Use `script/doctor` after setup to validate the shell, prompt, and installed tools, and to review any deferred items.

## Supported Systems

- macOS with Homebrew. If Homebrew is missing and sudo is available, `script/setup` installs it. Without sudo, Homebrew packages are deferred.
- Debian/Ubuntu-style Linux with `apt-get`. Without sudo, setup falls back to user-local static binaries and defers the rest.

Other Linux package managers are not automated yet.

## Installed Tools

`script/setup` installs or attempts to install:

- Shell/editor/session: `zsh`, `vim`, `tmux`, `git`
- Fuzzy search and navigation: `fzf`, `ripgrep`, `fd`, `z`
- Modern CLI tools: `eza` or `exa`, `bat`, `jq`, `yq`, `tree`, `coreutils`, `gnu-sed`, `grc`, `delta`, `gh`, `httpie`, `tldr`/`tlrc`
- System inspection: `duf`, `dust`, `ncdu`, `bottom`, `shellcheck`, `shfmt`
- Environment tools: `direnv`, `pyenv`, `rbenv`, `pipx`, `pipenv`, `uv`, `node`, `npm`, `nvm`, `conda` via Miniforge on macOS
- Media/cloud tools: `imagemagick`, `ffmpeg`, `awscli`, `rclone`, `yt-dlp`, `sqlite`
- File watching: `watchman`
- Prompt/fonts: Powerline-compatible fonts, JetBrains Mono Nerd Font on macOS, and `powerline-status`

On Linux, package names vary by distro version. Optional packages are attempted individually and skipped if unavailable. Setup also normalizes common Ubuntu binary names by linking `fd` to `fdfind` and `bat` to `batcat` in `~/.local/bin` when needed.

For `eza --icons` to render correctly, configure your terminal font to a Nerd Font. On macOS setup installs `JetBrainsMono Nerd Font`; in iTerm2 set your profile font to `JetBrainsMono Nerd Font`.

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
sudo -v
script/setup
```

## Structure

- `bin/`: executables added to `$PATH`
- `topic/*.zsh`: shell configuration loaded by Zsh
- `topic/*.symlink`: linked to `~/.$name`
- `script/setup`: full install (packages, symlinks, shell setup, topic installers)
