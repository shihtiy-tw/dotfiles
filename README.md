# Dotfiles

A comprehensive collection of configuration files for a productive development environment.

## Overview

This repository contains my personal configuration files for various tools and applications I use daily. The setup is designed to be modular, easily deployable, and supports both light and dark themes.

## Features

- **Shell**: ZSH with Oh-My-ZSH and custom plugins
- **Terminal Multiplexer**: tmux with session persistence and theme switching
- **Editors**:
  - Vim with custom keybindings and plugins
  - Neovim with Lua configuration
- **Terminal Emulators**: Configurations for kitty, ghostty, and alacritty
- **Version Control**: Git configuration with useful aliases
- **AWS & Kubernetes**: Tools and configurations for cloud development
- **Theme Support**: Automatic switching between light and dark themes

## Directory Structure

```
dotfiles/
├── alacritty/       # Alacritty terminal configuration
├── aws/             # AWS CLI configuration
├── bash/            # Bash shell configuration
├── git/             # Git configuration and aliases
├── ghostty/         # Ghostty terminal configuration
├── kitty/           # Kitty terminal configuration
├── make/            # Makefile scripts and environment variables
├── misc/            # Miscellaneous configurations
├── nvim/            # Neovim configuration (Lua-based)
├── tmux/            # tmux configuration and themes
├── vim/             # Vim configuration
├── xmodmap/         # X keyboard mapping
└── zsh/             # ZSH configuration and themes
```

## Installation

### Quick Start

```bash
# Clone the repository
git clone https://github.com/shihtiy-tw/dotfiles.git ~/dotfiles

# Install dependencies
make install

# Set up symlinks and configure environment
make init
```

### Additional Commands

```bash
# Switch to dark theme
make dark

# Switch to light theme
make light

# Check status of dotfiles
make status

# View differences between local and repository files
make diff
```

## Customization

Most configurations are modular and can be modified independently:

- Shell aliases and functions: `zsh/alias.zsh` and `zsh/function.zsh`
- tmux key bindings: `tmux/tmux.conf`
- Vim/Neovim settings: `vim/vimrc` and `nvim/init.lua`

## Backup Strategy

The installation process automatically creates backups of your existing configuration files before replacing them with symlinks to this repository.

## Credits

This configuration is inspired by and borrows from:
- [GitHub does dotfiles](https://dotfiles.github.io/)
- [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles)
- [Inndy's vimrc](https://github.com/Inndy/dotfiles/blob/master/vimrc)
- [PastLeo's tmux configuration](https://5xruby.tw/en/posts/tmux)

## License

Feel free to use and modify these configurations for your own use.
