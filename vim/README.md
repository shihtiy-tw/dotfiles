# Vim Configuration

A comprehensive Vim configuration with plugins and custom settings for efficient text editing.

## Structure

- `vimrc` - Main configuration file (symlinked to `~/.vimrc`)
- `editorconfig` - EditorConfig settings for consistent coding styles
- `test/` - Test files for different programming languages

## Features

- Syntax highlighting
- File type detection
- Indentation settings
- Custom key mappings
- Plugin management
- Color scheme configuration
- Status line customization
- EditorConfig integration

## Installation

The main dotfiles `make init` command will set up the Vim configuration automatically.

For manual installation:
```bash
# Create symlinks
ln -sf ~/dotfiles/vim/vimrc ~/.vimrc
ln -sf ~/dotfiles/vim/editorconfig ~/.editorconfig
```

## Key Mappings

The configuration includes various custom key mappings to improve productivity. Check the `vimrc` file for details.

## EditorConfig

The included `.editorconfig` file helps maintain consistent coding styles across different editors and IDEs. It defines:

- Indentation style (spaces vs tabs)
- Indentation size
- Line ending format
- Character encoding
- Trimming of trailing whitespace

## Testing

The `test/` directory contains sample files for testing Vim's syntax highlighting and other features with different programming languages:

- C
- Go
- Python
- Shell scripts
