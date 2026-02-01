# Ghostty Configuration

## Highlights
- **Next-Gen Terminal**: Configuration for Ghostty, a modern, fast, and feature-rich terminal.
- **Theme Support**: Integrated with the repository's central theme management.

## Structure
- `ghostty.conf`: Main configuration file (symlinked to `~/.config/ghostty/config`).
- `themes/`: Directory containing specific theme definitions.

## Installation
Handled automatically by `make init`.

## Theme Switching
Ghostty supports live config reloading. The `make dark` and `make light` commands update the configuration to point to the appropriate theme in `themes/`.
