# Tmux Configuration

## Highlights
- **Resilience**: `tmux-continuum` automatically saves your environment. storage.
- **Navigation**: Vim-like pane switching (`Ctrl+h/j/k/l`).
- **Theming**: Dynamic switching between **Everforest Dark** and **Light** themes via `make dark/light`.

## Structure
- `tmux.conf`: The main config file (symlinked to `~/.tmux.conf`).
- `themes/`: Theme definitions sourced by the scripts.

## Critical Keybindings
**Prefix:** `Ctrl + a`

| Key | Action |
| :--- | :--- |
| `Prefix + s` | **New Session** |
| `Prefix + [` | Copy Mode (Vim style) |
| `Prefix + h/j/k/l` | Navigate Panes |
| `Prefix + H/J/K/L` | Resize Panes |
| `Prefix + I` | Install Plugins (TPM) |

## Plugins via TPM
- **tmux-resurrect**: Saves session state.
- **tmux-continuum**: Auto-saves every 15 mins.
- **tmux-yank**: System clipboard integration.
- **tmux-fzf**: Fuzzy finding for session switching.
