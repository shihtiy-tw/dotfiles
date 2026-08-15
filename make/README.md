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
`color-theme.sh light|dark` first tells the OS to change mode, using whichever
tool the platform provides, then updates the tools that cannot follow the OS by
themselves:

- **OS mode**: `darkman set` on Linux, System Events via `osascript` on macOS.
  On Linux this also runs the hooks in `misc/darkman/{dark,light}-mode.d/`, which
  set the Plasma look-and-feel and the wallpaper.
- **Tmux**: `tmux/themes/switch-theme.sh`, which swaps the everforest variant and
  reloads it in any running server. Also runs on its own at tmux startup and on
  every light/dark transition, so tmux follows the OS without `make`.
- **Kitty**: symlinks `~/.config/kitty/theme.conf` at the right theme and sends
  running instances `SIGUSR1` to reload.
- **Zsh**: writes `export THEME=<mode>` to `zsh/theme.zsh`. Note that `zsh/zshrc`
  currently has the `source` line for it commented out.

Alacritty, Ghostty and Neovim are not wired into this script.
