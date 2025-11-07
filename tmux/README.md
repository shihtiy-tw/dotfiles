# Tmux Configuration

A powerful tmux configuration with custom keybindings, plugins, and theme support.

## Features

- Custom prefix key (`Ctrl+a`)
- Session persistence with tmux-resurrect and tmux-continuum
- Easy navigation between panes and windows
- Vim-like keybindings
- Automatic theme switching (light/dark)
- Copy-paste integration with system clipboard
- Status line customization

## Structure

- `tmux.conf` - Main configuration file (symlinked to `~/.tmux.conf`)
- `themes/` - Theme files for different color schemes
  - `tmux-gruvbox-dark.conf` - Dark theme configuration
  - `tmux-gruvbox-light.conf` - Light theme configuration

## Key Bindings

### Session Management
- `Prefix + d` - Detach from session
- `Prefix + S` - Create new session
- `Prefix + K` - Kill session

### Window/Pane Navigation
- `Prefix + h` / `Ctrl+h` - Previous window
- `Prefix + l` / `Ctrl+l` - Next window
- `Prefix + j` / `Ctrl+j` - Previous pane
- `Prefix + k` / `Ctrl+k` - Next pane
- `Prefix + x` - Select next pane and zoom

### Window/Pane Creation
- `Prefix + "` - Split window horizontally
- `Prefix + %` - Split window vertically

### Resizing Panes
- `Prefix + H` - Resize pane left
- `Prefix + J` - Resize pane down
- `Prefix + K` - Resize pane up
- `Prefix + L` - Resize pane right

### Copy Mode
- `Prefix + [` - Enter copy mode
- `v` - Begin selection (in copy mode)
- `y` - Copy selection (in copy mode)
- `Prefix + ]` / `Ctrl+p` - Paste buffer

### Other
- `Prefix + R` - Reload tmux configuration
- `Prefix + P` - Enable synchronized panes
- `Prefix + N` - Disable synchronized panes
- `Prefix + E` - Send command to all panes/windows/sessions
- `Prefix + C-e` - Send command to all panes/windows in current session

## Plugins

- [tpm](https://github.com/tmux-plugins/tpm) - Tmux Plugin Manager
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) - Save/restore tmux sessions
- [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) - Continuous saving of tmux environment
- [tmux-easy-motion](https://github.com/IngoMeyer441/tmux-easy-motion) - EasyMotion-style navigation
- [tmux-yank](https://github.com/tmux-plugins/tmux-yank) - Copy to system clipboard
- [tmux-dark-notify](https://github.com/erikw/tmux-dark-notify) - Auto theme switching
- [tmux-gruvbox](https://github.com/egel/tmux-gruvbox) - Gruvbox theme for tmux

## Installation

The main dotfiles `make init` command will set up the tmux configuration automatically.

For manual installation:
```bash
# Create necessary directories
mkdir -p ~/.config/tmux

# Create symlinks
ln -sf ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf

# Install TPM if not already installed
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh
```

## Troubleshooting

If plugins aren't working properly, try:
```bash
# Manually install plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Source plugins
~/.tmux/plugins/tpm/scripts/source_plugins.sh
```
