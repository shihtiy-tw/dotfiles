# Agent Guide: Dotfiles Project Context

This guide provides the necessary context for AI agents working on this dotfiles repository.

## Project Philosophy
- **Modular Monorepo**: Each tool (zsh, nvim, tmux, etc.) has its own directory with dedicated READMEs.
- **AI-Native**: Deeply integrated with agentic coding tools (**OpenCode**).
- **Orchestrated by Make**: The `Makefile` is the primary interface for all operations.

## Core Locations & Entry Points

| Component | Path | Description | Target Link |
| :--- | :--- | :--- | :--- |
| **Neovim** | `nvim/` | Lua-based config with `lazy.nvim` | `~/.config/nvim/` |
| **Shell (Zsh)** | `zsh/` | OMZ-based with custom aliases | `~/.zshrc` |
| **Tmux** | `tmux/` | Config with TPM and theme support | `~/.tmux.conf` |
| **AI Config** | `opencode/` | OpenCode & MCP configuration | `~/.config/opencode/` |
| **Orchestration**| `make/` | Init, installation, and theme logic | N/A |

## Management Patterns

### 1. Symlinking (The "Link" Phase)
- **Primary Mechanism**: `make init` calls `make/init.sh`.
- **Safety**: The `link_config` function creates timestamped backups (e.g., `.zshrc.backup.1707312345`) before replacing files.
- **Exception**: Arch Linux (`make/install-archlinux.sh`) uses `stow` for certain package categories.
- **Agent Rule**: Edit source files in `~/dotfiles/`, then run `make init`. NEVER edit files in `$HOME` directly.

### 2. Installation (The "Install" Phase)
- **Mechanism**: `make install` triggers `make/install-init.sh`, which detects the OS (Ubuntu, Arch, Mac, Amazon Linux) and runs the corresponding script.
- **Agent Rule**: Update OS-specific scripts in `make/` when adding new tool dependencies.

### 3. Theme Management
- **Mechanism**: `make dark` and `make light` execute `make/color-theme.sh`.
- **Logic**: The OS owns the current mode, and tools follow it. `color-theme.sh`
  sets the mode with the platform's own tool (`darkman set` on Linux, System
  Events via `osascript` on macOS), then updates the tools that have no watcher
  of their own (kitty, `zsh/theme.zsh`).
- **Tmux**: `tmux/themes/switch-theme.sh light|dark` is the single entry point.
  It is called by the darkman hooks in `misc/darkman/{dark,light}-mode.d/` on
  Linux, by `erikw/tmux-dark-notify` on macOS, and by `tmux.conf` itself (with
  no argument, so it auto-detects) on every server start. It records the choice
  in `~/.local/state/tmux/tmux-dark-notify-theme.conf`, which `tmux.conf`
  sources, so a new server does not fall back to the everforest plugin's
  built-in dark default.
- **Agent Rule**: Ensure UI-related changes respect the **Everforest** and **Gruvbox** color schemes.

## AI Agent Integration

- **OpenCode**: Configured in `opencode/opencode.jsonc`. Uses Gemini 3.0 (Reasoning) and Ollama/Qwen (Local).
- **MCP Servers**: `readwise` and `sequential-thinking` are enabled by default.

## Instructions for Agents

1.  **Atomic Changes**: Keep configurations modular. Use tool-specific directories.
2.  **Verify via Make**: After any change, run `make test` to verify symlinks and installation status.
3.  **Bare Repo Alias**: Be aware of the `config` alias for direct home directory Git tracking:
    `alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`
4.  **No Type Suppression**: Never use `as any` or `@ts-ignore` in Lua or JSONC configs.

## Verification Checklist
- [ ] Symlinks are valid (`make test-symlinks`).
- [ ] Installation is clean (`make test-install`).
- [ ] Neovim `lazy.nvim` health is good.
- [ ] Tmux config reloads without errors (`tmux source ~/.tmux.conf`).
