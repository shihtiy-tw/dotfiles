# Dotfiles

## Overview
A collection of configuration files for a productive development environment. Optimized for **Linux** and **macOS**, featuring heavy integration with modern tools like **Neovim (Lua)**, **Tmux**, and **AI** agents.

## Key Features

| Domain | Tools | Highlights |
| :--- | :--- | :--- |
| **Editor** | [Neovim](./nvim/README.md) | **Avante.nvim (Gemini + Local LLMs)**, Lazy.nvim, LSP-Zero |
| **Shell** | [Zsh](./zsh/README.md) / [Bash](./bash/README.md) | Custom plugins, `bash-it` integration, cross-shell aliases |
| **Terminal** | [Tmux](./tmux/README.md) | Persistence (Continuum), Auto-theming (Dark/Light), FZF navigation |
| **Infrastructure** | [Make](./make/README.md) | Automated installation & symlinking, OS detection |
| **AI Agents** | [OpenCode](./opencode/README.md) | Config for `gemini-cli`, `ollama`, and MCP servers |

## Directory Structure

```text
dotfiles/
├── alacritty/       # Alacritty configuration
├── aws/             # AWS CLI & Amazon Q
├── bash/            # Bash framework & aliases
├── ghostty/         # Ghostty terminal config
├── git/             # Git config & commit templates
├── kitty/           # Kitty terminal config
├── make/            # Installation scripts & orchestration
├── misc/            # Darkman & Xmodmap
├── nix/             # Nix flakes config
├── nvim/            # Neovim (The Beast)
├── opencode/        # AI Agent Code Config
├── tmux/            # Tmux & TPM
├── vim/             # Legacy Vim config
└── zsh/             # Zsh framework & aliases
```

## Installation

### Quick Start
```bash
# 1. Clone
git clone https://github.com/shihtiy-tw/dotfiles.git ~/dotfiles

# 2. Install Dependencies (OS specific)
cd ~/dotfiles
make install

# 3. Symlink Configurations
make init
```

### Theme Switching
Toggle your entire system between Light and Dark modes instantly:
```bash
make dark   # Switch to Dark Mode (Everforest Dark / Gruvbox)
make light  # Switch to Light Mode (Everforest Light)
```

## Credits
Inspired by:
- [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles)
- [Inndy's vimrc](https://github.com/Inndy/dotfiles)
- [PastLeo's tmux](https://5xruby.tw/en/posts/tmux)
