# Neovim Configuration

A modern, Lua-based Neovim configuration designed for efficient coding and text editing.

## Structure

- `init.lua` - Main configuration entry point
- `lua/` - Lua-based configuration modules
  - `configs/` - Plugin-specific configurations
    - `formatter/` - Code formatting settings
    - `lint/` - Linting configurations
    - `schema/` - JSON schema settings
  - `plugins/` - Plugin definitions and settings
- `vimscript/` - Legacy Vim script configurations
- `coc-settings.json` - CoC (Conquer of Completion) settings

## Features

- Modern Lua-based configuration
- Lazy-loaded plugins for fast startup
- LSP (Language Server Protocol) integration
- Code formatting and linting
- Syntax highlighting and treesitter support
- Git integration
- File navigation and fuzzy finding
- Statusline customization

## Dependencies

- Neovim >= 0.8.0
- Git
- Node.js (for LSP features)
- A Nerd Font for icons
- ripgrep (for telescope file searching)

## Installation

The main dotfiles `make init` command will set up the Neovim configuration automatically.

For manual installation:
```bash
# Create necessary directories
mkdir -p ~/.config/nvim

# Create symlinks
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/nvim/lua ~/.config/nvim/lua
ln -sf ~/dotfiles/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
```

## Troubleshooting

Run these commands inside Neovim to diagnose issues:
```
:checkhealth provider
:CheckHealth
```

Common issues:
- Missing clipboard provider: Install xclip (Linux) or pbcopy/pbpaste (macOS)
- LSP not working: Check if the language server is installed
- Plugin errors: Run `:Lazy` to check plugin status

## Keybindings

See the `lua/plugins/which-key.lua` file for a complete list of keybindings.

## TODO
- Add clipboard integration with [nvim-neoclip.lua](https://github.com/AckslD/nvim-neoclip.lua)
