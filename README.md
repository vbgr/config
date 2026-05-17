# Config

Personal macOS configuration files. This repository is intended to live at
`~/.config`.

## Layout

| Path | Destination | Purpose |
| --- | --- | --- |
| `alacritty/` | `~/.config/alacritty` | Alacritty terminal configuration |
| `fonts/` | `~/Library/Fonts` | SF Mono Nerd Font files used by Alacritty |
| `nvim/` | `~/.config/nvim` | Neovim configuration |
| `tmux/` | `~/.config/tmux` | tmux configuration and helper scripts |
| `zsh/` | `~/.config/zsh` | Zsh configuration, aliases, completions, and plugins |
| `defaults.sh` | run from repo root | macOS defaults and global Git aliases |

## Install

Clone or copy this repository to `~/.config`:

```sh
git clone git@github.com:vbgr/config.git ~/.config
```

If `~/.config` already exists, copy the repository contents into that directory
instead.

## Fonts

Alacritty uses `Liga SFMono Nerd Font`. Install the bundled font files by
copying them to `~/Library/Fonts`:

```sh
mkdir -p ~/Library/Fonts
cp ~/.config/fonts/*.otf ~/Library/Fonts/
```

Restart Alacritty after installing or updating fonts.

## Alacritty

Alacritty reads this config from:

```text
~/.config/alacritty/alacritty.toml
```

No symlink is required when this repository is located at `~/.config`.

## Zsh

The Zsh config lives in:

```text
~/.config/zsh
```

Create symlinks for the shell entrypoint files:

```sh
ln -sfn ~/.config/zsh/zshenv ~/.zshenv
ln -sfn ~/.config/zsh/zshrc ~/.zshrc
```

The Zsh config sources files from `~/.config/zsh/lib`, loads plugins from
`~/.config/zsh/plugins`, and starts tmux automatically when not already inside
tmux or Neovim.

## tmux

The tmux config lives in:

```text
~/.config/tmux
```

Create the tmux config symlink:

```sh
ln -sfn ~/.config/tmux/tmux.conf ~/.tmux.conf
```

The tmux config sources `keys.tmux` and `style.tmux` from `~/.config/tmux`.

## Neovim

The tracked Neovim config lives in:

```text
~/.config/nvim
```

Neovim will load:

```text
~/.config/nvim/init.lua
```

No symlink is required when this repository is located at `~/.config`.

## macOS Defaults

Run `defaults.sh` from the repository root to apply macOS defaults and Git
aliases:

```sh
cd ~/.config
sh defaults.sh
```

Some settings may require restarting affected applications or logging out and
back in.

