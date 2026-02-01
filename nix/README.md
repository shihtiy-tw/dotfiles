# Nix Configuration

## Highlights
- Enables **Nix Flakes** for reproducible package management.
- Simple, minimalist configuration.

## Structure
- `nix.conf`: The core configuration file (symlinked to `~/.config/nix/nix.conf` or `/etc/nix/nix.conf` depending on setup).

## Usage
This config primarily enables experimental features required for modern Nix usage:
```nix
experimental-features = nix-command flakes
```
