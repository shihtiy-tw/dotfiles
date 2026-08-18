# Dotfiles

## Overview
A collection of configuration files for a productive development environment. Optimized for **Linux** and **macOS**, featuring heavy integration with modern tools like **Neovim (Lua)**, **Tmux**, and **AI** agents.

## Key Features

| Domain | Tools | Highlights |
| :--- | :--- | :--- |
| **Editor** | [Neovim](./nvim/README.md) | Lazy.nvim, mason + nvim-lspconfig, `opencode.nvim`, Kubernetes/YAML tooling |
| **Shell** | [Zsh](./zsh/README.md) / [Bash](./bash/README.md) | Custom plugins, `bash-it` integration, cross-shell aliases |
| **Terminal** | [Tmux](./tmux/README.md) | Persistence (Continuum), Auto-theming (Dark/Light), FZF navigation |
| **Infrastructure** | [Make](./make/README.md) | Automated installation & symlinking, OS detection, optional cloud/LLM tool sets |
| **Testing** | [Container harness](./make/test/README.md) | The installers run end-to-end in throwaway Ubuntu, Arch, Amazon Linux and Termux containers |
| **AI Agents** | [OpenCode](./opencode/README.md) | Config for `gemini-cli`, `ollama`, and MCP servers |

## Supported Platforms

`make install` dispatches on `uname` and `/etc/os-release` (see `make/install-init.sh`).
Anything not listed here exits 1 with an error rather than silently doing nothing.

| Platform | Installer | Status |
| :--- | :--- | :--- |
| Ubuntu / Linux Mint | `make/install-ubuntu.sh` | Verified end-to-end in a container |
| Arch Linux | `make/install-archlinux.sh` | Verified; GUI and hardware packages sit behind `DOTFILES_HEADLESS` |
| Amazon Linux 2023 | `make/install-amazon-linux.sh` | Verified end-to-end in a container |
| macOS | `make/mac/install-mac.sh` | Reviewed statically only — macOS cannot be containerized, so it is unverified |
| Termux (Android) | none | Refused with a message. `bash make/init.sh` does work; `make/install-termux.sh` does not |
| Debian, Fedora, Manjaro | none | No dispatch arm yet |

## Directory Structure

```text
dotfiles/
├── alacritty/       # Alacritty configuration
├── aws/             # AWS CLI & Amazon Q
├── bash/            # Bash framework & aliases
├── ghostty/         # Ghostty terminal config
├── git/             # Git config & commit templates
├── .issues/         # In-repo issue tracker (git-issue format)
├── kitty/           # Kitty terminal config
├── make/            # Installation scripts, orchestration & container tests
├── misc/            # Darkman & Xmodmap
├── nix/             # Nix flakes config
├── nvim/            # Neovim (The Beast)
├── opencode/        # AI Agent Code Config
├── tmux/            # Tmux & TPM
├── vim/             # Legacy Vim config
├── zsh/             # Zsh framework & aliases
├── AGENTS.md        # Conventions for AI agents working in this repo
└── Makefile         # Entry point for every task below
```

## Installation

### Read this first

`make install` is a provisioning script for a *new* machine, not a config sync. On an
existing system it will:

- **Remove distro Docker packages** before installing Docker CE — on Ubuntu it runs
  `apt-get remove -y` over `docker.io`, `docker-compose`, `podman-docker`, `containerd`
  and `runc`. If you rely on Podman or the distro Docker, you will lose it.
- **Add the mainline kernel PPA and run `apt full-upgrade -y`** on Ubuntu.
- **Pull >10 GB of GUI and hardware packages on Arch** (firefox, libreoffice, gimp,
  obs-studio, cuda, nvidia-utils, virtualbox, wine). Set `DOTFILES_HEADLESS=1` to skip
  them.

`make init` replaces these paths with symlinks into the repo. Anything already there is
moved to `<path>.backup.<epoch>` first, and the link is skipped if the backup fails:

`~/.zshrc`, `~/.gitconfig`, `~/.vimrc`, `~/.editorconfig`, `~/.tmux.conf`,
`~/.config/tmux/tmux.conf`, `~/.config/nvim/init.lua`, `~/.config/nvim/lua`,
`~/.aws/config`, `~/.config/kitty/kitty.conf`, `~/.config/ghostty/config`,
`~/.config/alacritty/alacritty.yml`, `~/.config/opencode/opencode.jsonc`.

To see exactly what an installer would do to a machine that is not yours, run it in a
container first: `make test-container`.

### Quick Start
```bash
# 1. Clone. The path matters: make/init.sh resolves configs from ~/dotfiles.
git clone https://github.com/shihtiy-tw/dotfiles.git ~/dotfiles

# 2. Install Dependencies (OS specific)
cd ~/dotfiles
make install

# 3. Symlink Configurations
make init
```

### Optional Tool Sets

`make install` deliberately leaves these out — they are large, or need credentials, or
are only wanted on some machines. Each is independent and safe to re-run.

```bash
make aws          # AWS CLI v2 + Session Manager plugin
make gcp          # gcloud CLI + GKE auth plugin
make azure        # Azure CLI
make kubernetes   # kubectl, eksctl, helm, krew (+plugins), k9s, kustomize, kubecolor
make cloud        # all four of the above
make llm          # uv, Simon Willison's llm + Ollama plugin, Gemini CLI
make tui          # basalt, parllama, GitHub CLI + gh-dash
```

Not every tool exists on every platform. Where upstream publishes nothing usable — the
AWS and Azure CLIs on Termux, for instance — the installer records it as *unsupported*
and still exits 0, rather than reporting a failure it cannot fix.

### Theme Switching
Toggle your entire system between Light and Dark modes instantly:
```bash
make dark   # Switch to Dark Mode (Everforest Dark / Gruvbox)
make light  # Switch to Light Mode (Everforest Light)
```

## Testing

```bash
make test              # assert the expected tools and symlinks on this machine
make test-symlinks     # symlinks only
make test-container    # run the installers in containers, fast phase (~1 min per distro)
```

The container harness is the only honest way to check the installers, since they are
almost pure side effects. See [make/test/README.md](./make/test/README.md) for the phases
and [make/test/FINDINGS.md](./make/test/FINDINGS.md) for what the audit found.

## Issue Tracking

Issues live in the repo under `.issues/`, in [git-issue](https://github.com/dspinellis/git-issue)
format, so they are versioned and available offline. The `git issue` alias in
`git/gitconfig` points at a path that will not exist on your machine, so read
[.issues/README.md](./.issues/README.md) first — it covers installing the tool, and how to
read the issues with plain shell commands until you do.

## Credits
Inspired by:
- [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles)
- [Inndy's vimrc](https://github.com/Inndy/dotfiles)
- [PastLeo's tmux](https://5xruby.tw/en/posts/tmux)
