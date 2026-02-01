# Kitty Configuration

## Highlights
- **Solarized & Gruvbox**: Pre-configured themes matching the system-wide aesthetic.
- **Performance**: GPU-accelerated terminal emulator settings.

## Structure
- `kitty.conf`: The main configuration file (symlinked to `~/.config/kitty/kitty.conf`).
- `Solarized_Light.conf`: Light theme.
- `gruvbox_dark.conf`: Dark theme.

## Installation
The root `make init` command handles symlinking:
```bash
ln -sf ~/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf
```

## Theme Switching
Run `make dark` or `make light` in the root directory. This triggers the `color-theme.sh` script which swaps the include in `kitty.conf` or updates the theme file directly.
