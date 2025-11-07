# Miscellaneous Configurations

This directory contains various configuration files that don't fit into other categories.

## Structure

- `darkman/` - Configuration for Darkman (dark mode manager)
  - `dark-mode.d/` - Scripts to run when switching to dark mode
  - `light-mode.d/` - Scripts to run when switching to light mode
- `xmodmap/` - X keyboard mapping configuration

## Darkman

Darkman is a tool that automatically switches between light and dark themes based on time or system settings.

### Usage

The configuration in this directory allows automatic theme switching for various applications when the system switches between light and dark modes.

### Configuration

- `darkman/dark-mode.d/` contains scripts that run when switching to dark mode
- `darkman/light-mode.d/` contains scripts that run when switching to light mode

## Xmodmap

Xmodmap is used to modify key mappings in the X Window System.

### Usage

The configuration in this directory customizes keyboard behavior in X11 environments.

### Configuration

- `xmodmap/xinitrc` - X initialization script with keyboard mapping settings

## Installation

The main dotfiles `make init` command will set up these configurations automatically.

For manual installation:
```bash
# Create symlinks for xmodmap
ln -sf ~/dotfiles/misc/xmodmap/xinitrc ~/.xinitrc

# Set up darkman configuration
mkdir -p ~/.config/darkman
ln -sf ~/dotfiles/misc/darkman/config.yaml ~/.config/darkman/config.yaml
ln -sf ~/dotfiles/misc/darkman/dark-mode.d ~/.config/darkman/dark-mode.d
ln -sf ~/dotfiles/misc/darkman/light-mode.d ~/.config/darkman/light-mode.d
```
