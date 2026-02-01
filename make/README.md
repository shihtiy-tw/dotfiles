# Makefile & Installation Scripts

## Highlights
- **Orchestration**: The central hub for installing, updating, and managing the dotfiles.
- **Theme Switching**: Scripts to toggle the entire system between Light and Dark modes.
- **OS Detection**: Automatic installation scripts for MacOS, Ubuntu, Arch, and Amazon Linux.

## Structure
- `init.sh`: The core script that creates symlinks (the "link" phase).
- `install-*.sh`: OS-specific dependency installers (the "install" phase).
- `color-theme.sh`: Logic for switching themes (updates Vim, Tmux, Alacritty, etc.).
- `envfile`: Environment variables used by the Makefile.

## Make Commands
Run these from the root directory:

| Command | Description |
| :--- | :--- |
| `make install` | Installs system dependencies (apt/brew/pacman). |
| `make init` | Symlinks configurations to your home directory. |
| `make dark` | Switches system to **Dark Mode**. |
| `make light` | Switches system to **Light Mode**. |
| `make status` | Checks the git status of the dotfiles. |

## Theme Switching
The `color-theme.sh` script updates multiple tools simultaneously:
- **Alacritty/Kitty/Ghostty**: Swaps config files.
- **Tmux**: reload config active session.
- **Neovim**: Triggers background color change.
