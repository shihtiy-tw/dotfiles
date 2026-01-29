# Vim Configuration (Legacy)

## Highlights
- **Legacy Support**: Maintained for servers or environments where Neovim is unavailable.
- **Modular Config**: Split into specific files for keys, plugins, and general settings.
- **VimPlug**: Uses `vim-plug` for plugin management.

## Structure
- `vimrc`: The entry point (symlinked to `~/.vimrc`).
- `general.vimrc`: Basic editor settings (tabs, numbers, etc.).
- `keys.vimrc`: Key mappings.
- `plugins.vimrc`: Plugin list (VimPlug).
- `plugin_config.vimrc`: Configuration for installed plugins.
- `color.vimrc`: Theme settings.

## Note
This configuration is **separate** from the modern Neovim setup located in the `../nvim` directory. Use that for daily development.

## Installation
```bash
# Handled by the root Makefile
make install
```
