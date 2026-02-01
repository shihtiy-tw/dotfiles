# Miscellaneous Configurations

## Highlights
- **Darkman**: Automatic day/night theme switching configuration.
- **Xmodmap**: Custom keyboard mappings for Linux (X11).

## Structure
- `darkman/`: Configuration for the `darkman` tool.
    - `dark-mode.d/`: Scripts executed when switching to dark mode.
    - `light-mode.d/`: Scripts executed when switching to light mode.
- `xmodmap/`:
    - `xinitrc`: X11 initialization commands.

## Usage
### Darkman
Darkman acts as a background service to control the theme state. The scripts in `dark-mode.d` and `light-mode.d` hook into the rest of the system (likely calling the `make` commands or direct config swaps).

### Xmodmap
Symlinked to `~/.xinitrc` to ensure keys are remapped on login.
