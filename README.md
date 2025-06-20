# Dotfiles

Base installation for OSX and Ubuntu, tested on 18.04

## Install

Run this:

```sh
git clone --recursive git@github.com:your-username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
script/install
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

## User Configuration

After installation, customize the user configuration file:

```sh
# Copy the user configuration template
cp ~/.dotfiles/zsh/user-config.zsh ~/.dotfiles/zsh/user-config.zsh.local

# Edit the file to set your personal variables
vim ~/.dotfiles/zsh/user-config.zsh.local
```

The `zsh/user-config.zsh` file contains all the variables you need to customize for your setup, including usernames, paths, and optional tool configurations.

`dot` is a simple script that installs some dependencies, sets sane OS X
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.

## Updating Submodules

Be sure to update submodules with

    git submodule update --init

## It's Topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `script/bootstrap`.

You can even add folders named `whatever.symlink` and these will be symlinked as well.

## Components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.

## Thanks

Forked from [@holman's](http://github.com/holman)' excellent
[dotfiles](http://github.com/holman/dotfiles)
