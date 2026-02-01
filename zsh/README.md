# ZSH Configuration

## Highlights
- **Oh-My-Zsh**: Built on the popular framework.
- **Custom Functions**: Powerful utilities like `explain` (man page AI-like summary) and `cheat`.
- **Auto-Jump**: `j` command to fly between directories.

## Structure
- `zshrc`: Entry point.
- `alias.zsh`: Command shortcuts (e.g., `gs` -> git status).
- `function.zsh`: Advanced shell functions.
- `env.zsh`: Path and environment exports.

## Custom Tools
Run these from your terminal:
- `explain <command>`: Queries `mankier.com` to explain a CLI command.
- `cheat <command>`: Queries `cheat.sh` for examples.
- `mkdircd <dir>`: Make a directory and enter it immediately.

## Alias Cheat Sheet
| Alias | Command |
| :--- | :--- |
| `vim` | `nvim` (Aliases Vim to Neovim) |
| `c` | `clear` |
| `config` | Git command for dotfiles (See main README for setup) |
