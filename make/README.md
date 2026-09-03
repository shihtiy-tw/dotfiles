# Makefile & Installation Scripts

## Highlights
- **Orchestration**: The central hub for installing, linking, testing and theming.
- **Theme Switching**: Scripts to toggle the entire system between Light and Dark modes.
- **OS Detection**: `install-init.sh` dispatches on `uname` and `/etc/os-release`; an
  unsupported platform exits 1 with an explanation rather than silently doing nothing.
- **Container-tested**: `test/` runs the installers end-to-end in throwaway containers,
  which is the only honest way to check code that is almost pure side effects.

## Structure

```text
make/
├── install-init.sh        # dispatcher: picks the installer for this platform
├── install-ubuntu.sh      # Ubuntu / Linux Mint
├── install-archlinux.sh   # Arch (GUI + hardware behind DOTFILES_HEADLESS)
├── install-amazon-linux.sh
├── install-termux.sh      # present but NOT dispatched — see below
├── install-aws.sh         # ┐
├── install-gcp.sh         # │
├── install-azure.sh       # ├ opt-in tool sets, one make target each
├── install-kubernetes.sh  # │
├── install-llm.sh         # │
├── install-tui.sh         # ┘
├── init.sh                # the "link" phase: symlinks 13 paths into $HOME
├── remove-env.sh          # the reverse: restores the timestamped backups
├── color-theme.sh         # light/dark switching
├── test.sh                # local suite = test-install.sh + test-symlinks.sh
├── test-install.sh        # asserts expected tools on this machine
├── test-symlinks.sh       # asserts init.sh's links (--fix to repair)
├── envfile                # exported into every recipe's environment (GOPATH, PATH)
├── envtest.sh             # prints what envfile resolved to
├── modules/
│   ├── helpers/logger.sh  # log_*, safe_exec, record_failure, record_unsupported,
│   │                      #   install_summary — the shared ledger every installer uses
│   ├── helpers/pkg.sh
│   └── common/            # cross-distro installers: oh-my-zsh, nvm, pyenv, rustup,
│                          #   fzf, bun, autojump, gitflow, tmux-tpm, agent-deck,
│                          #   vibe-kanban  (see modules/README.md)
├── mac/                   # install-mac.sh, Brewfile.arm / Brewfile.x86, theme/,
│                          #   ToggleDarkMode.scpt  (see mac/README.md)
├── systemd/               # setup.sh + handwriting-ocr and rclone-sync .service/.timer
└── test/                  # container harness (see test/README.md)
```

## Make Commands

Run these from the repository root.

### Install and link

| Command | Description |
| :--- | :--- |
| `make install` | Dispatches to the installer for this platform (`install-init.sh`). |
| `make init` | Symlinks configurations into your home directory. |
| `make remove_env` | Undoes `make init`, restoring the newest `.backup.<epoch>`. |
| `make remove_env-dry-run` | Prints what `remove_env` would do, changing nothing. |

### Optional tool sets

Left out of `make install` because they are large, or need credentials, or are only wanted
on some machines. Each is independent and safe to re-run.

| Command | Installs |
| :--- | :--- |
| `make aws` | AWS CLI v2 + Session Manager plugin |
| `make gcp` | gcloud CLI + GKE auth plugin |
| `make azure` | Azure CLI |
| `make kubernetes` | kubectl, eksctl, helm, krew (+plugins), k9s, kustomize, kubecolor |
| `make cloud` | all four of the above |
| `make llm` | uv, Simon Willison's `llm` + Ollama plugin, Gemini CLI |
| `make tui` | basalt, parllama, GitHub CLI + gh-dash |

Where upstream publishes nothing usable for a platform — the AWS and Azure CLIs on
Termux, say — the installer calls `record_unsupported` and still exits 0, rather than
reporting a failure it cannot fix.

### Testing

| Command | Description |
| :--- | :--- |
| `make test` | Local suite: expected tools + symlinks on *this* machine. |
| `make test-verbose` | Same, with per-check output. |
| `make test-install` | Tool checks only. |
| `make test-symlinks` | Symlink checks only. |
| `make test-fix` | Repairs any missing/wrong symlinks. |
| `make test-container` | Installers in containers, fast phase (~1 min per distro). |
| `make test-container-full` | Full end-to-end installer run. |
| `make test-container-extras` | The six optional tool-set installers. |

See [test/README.md](./test/README.md) for the harness and
[test/FINDINGS.md](./test/FINDINGS.md) for what the audit turned up.

### Theming and misc

| Command | Description |
| :--- | :--- |
| `make dark` | Switches the system to **Dark Mode**. |
| `make light` | Switches the system to **Light Mode**. |
| `make help` | Lists the targets (also the default target). |
| `make env` | Echoes the `envfile` variables and runs `envtest.sh`. |
| `make hello` | ASCII banner. |

### Bare-repo targets

`make status`, `make diff`, `make add`, `make commit` and `make ls` all run git against
`--git-dir=$HOME/.dotfiles/ --work-tree=$HOME` — a **bare** repo tracking `$HOME`
directly. That is a different layout from this checkout, which lives at `~/dotfiles` and
uses symlinks. Unless you have set that bare repo up yourself, these targets do not
inspect this repository; use plain `git` for that. The `config` alias in
`zsh/alias.zsh:14` is the same thing.

## Platform support

| Platform | Detected by | Installer |
| :--- | :--- | :--- |
| Ubuntu / Linux Mint | `ID=ubuntu` \| `linuxmint` | `install-ubuntu.sh` |
| Arch Linux | `ID=arch` | `install-archlinux.sh` |
| Amazon Linux 2023 | `ID=amzn` | `install-amazon-linux.sh` |
| macOS | `uname = Darwin` | `mac/install-mac.sh` |
| Termux (Android) | `uname -o = Android`, or `$PREFIX` under `com.termux` | **refused**, exit 1 |
| anything else | — | exit 1 |

Termux is detected *first* and deliberately refused with guidance to run
`bash make/init.sh` instead: `install-termux.sh` exists but is not wired to any target,
because it clones a second copy of the repo into the CWD, never calls `init.sh`, and ends
in an interactive TUI. Debian, Fedora and Manjaro have no dispatch arm yet.

`DOTFILES_HEADLESS=1` skips the GUI and hardware blocks in `install-archlinux.sh` — over
10 GB of firefox, libreoffice, gimp, obs-studio, cuda, nvidia-utils, virtualbox and wine,
plus input methods, terminal emulators and the zed editor. Worth setting on any server or
VM, not just in the test containers (where `test/run.sh` sets it by default).

## Theme Switching

`color-theme.sh light|dark` first tells the OS to change mode, using whichever tool the
platform provides, then updates the tools that cannot follow the OS by themselves:

- **OS mode**: `darkman set` on Linux, System Events via `osascript` on macOS.
  On Linux this also runs the hooks in `misc/darkman/{dark,light}-mode.d/`, which set the
  Plasma look-and-feel and the wallpaper, and re-run the tmux script below.
- **Tmux**: `tmux/themes/switch-theme.sh`, which swaps the everforest variant and reloads
  it in any running server. Also runs on its own at tmux startup and on every light/dark
  transition, so tmux follows the OS without `make`.
- **Kitty**: symlinks `~/.config/kitty/theme.conf` at the right theme and sends running
  instances `SIGUSR1` to reload.
- **Zsh**: writes `export THEME=<mode>` to `zsh/theme.zsh`, which `zsh/zshrc:50` sources.

Alacritty, Ghostty and Neovim are not wired into this script. Neovim follows the OS on its
own via `auto-dark-mode.nvim`.
