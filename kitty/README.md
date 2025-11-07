# Kitty Terminal Configuration

Configuration for the Kitty terminal emulator, a fast, feature-rich, GPU-based terminal.

## Features

- Custom color scheme
- Font configuration
- Keyboard shortcuts
- Window layout settings
- Tab management
- SSH integration

## Installation

The main dotfiles `make init` command will set up the Kitty configuration automatically.

For manual installation:
```bash
# Create necessary directories
mkdir -p ~/.config/kitty

# Create symlink
ln -sf ~/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf
```

## SSH Integration

When using SSH with Kitty, you might encounter the following error:
```
missing or unsuitable terminal: xterm-kitty
```

### Solution

Use the Kitty SSH kitten:
```bash
kitten ssh remote-server
```

Alternatively, you can add this to your `.bashrc` or `.zshrc`:
```bash
alias ssh="TERM=xterm-256color ssh"
```

## Customization

You can customize the configuration by editing the `kitty.conf` file. Some common customizations:

- Change font: `font_family`, `font_size`
- Adjust colors: `foreground`, `background`, `color0` through `color15`
- Modify keyboard shortcuts: `map` directives

## Resources

- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/conf/)
- [Kitty Themes](https://github.com/dexpota/kitty-themes)
