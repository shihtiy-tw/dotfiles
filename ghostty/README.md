# Ghostty Configuration

Configuration for Ghostty, a fast, feature-rich terminal emulator with excellent rendering capabilities.

## Features

- Custom color schemes
- Font configuration
- Window settings
- Key bindings
- Performance optimizations

## Installation

The main dotfiles `make init` command will set up the Ghostty configuration automatically.

For manual installation:
```bash
# Create necessary directories
mkdir -p ~/.config/ghostty

# Create symlink
ln -sf ~/dotfiles/ghostty/ghostty.conf ~/.config/ghostty/config
```

## Configuration

Ghostty is configured using a simple configuration file. The configuration includes:

- Terminal colors
- Font settings
- Window dimensions and appearance
- Key bindings
- Performance settings

## Customization

You can customize the configuration by editing the `ghostty.conf` file. Some common customizations:

- Change font: Update the font-related settings
- Adjust colors: Modify the color settings
- Change window appearance: Update window-related settings

## Resources

- [Ghostty Website](https://ghostty.org/)
- [Ghostty Documentation](https://ghostty.org/docs/)
