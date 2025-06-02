# Alacritty Configuration

Configuration for Alacritty, a fast, cross-platform, GPU-accelerated terminal emulator.

## Features

- Custom color schemes
- Font configuration
- Key bindings
- Window settings
- Performance optimizations

## Installation

The main dotfiles `make init` command will set up the Alacritty configuration automatically.

For manual installation:
```bash
# Create necessary directories
mkdir -p ~/.config/alacritty

# Create symlink
ln -sf ~/dotfiles/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
```

## Configuration

Alacritty is configured using a YAML file. The configuration includes:

- Terminal colors
- Font settings (family, size, style)
- Window dimensions and padding
- Scrolling behavior
- Key bindings
- Mouse settings
- Performance settings

## Customization

You can customize the configuration by editing the `alacritty.yml` file. Some common customizations:

- Change font: Update the `font` section
- Adjust colors: Modify the `colors` section
- Change window size: Update the `window` section

## Resources

- [Alacritty GitHub Repository](https://github.com/alacritty/alacritty)
- [Alacritty Documentation](https://github.com/alacritty/alacritty/blob/master/docs/features.md)
- [Example Configuration](https://github.com/alacritty/alacritty/blob/master/alacritty.yml)
