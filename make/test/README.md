# Container tests for the installers

`make/install-*.sh` are pure side-effect scripts: ~238 `sudo` calls, ~40 network
downloads, and symlinks into `$HOME`. The only honest way to know whether they still
work is to run them in a disposable OS.

**Never run the installers on your own machine.** `install-ubuntu.sh` removes the
host's container runtime, adds a mainline-kernel PPA and runs `full-upgrade`;
`init.sh` overwrites `~/.zshrc`, `~/.gitconfig`, `~/.aws/config` and
`~/.config/nvim/*`.

## Usage

```sh
make test-container            # fast phase, all four distros  (~1 min each)
make test-container-full       # full installers               (20-60 min each)
make test-container-extras     # the optional tool sets

./make/test/run.sh --phase fast ubuntu
./make/test/run.sh --phase full archlinux --no-headless   # include the ~10GB of GUI packages
./make/test/run.sh --phase extras ubuntu                  # the optional tool sets only
./make/test/run.sh --keep-image ubuntu                    # skip the image rebuild
./make/test/run.sh --help
```

With no distro argument, all four run. Every flag also accepts the `--flag=value` form.

| Flag | Env var | Default | Applies to |
| :--- | :--- | ---: | :--- |
| `--timeout` | `INSTALL_TIMEOUT` | 3600 | the `full` phase's installer step |
| `--extras-timeout` | `EXTRAS_TIMEOUT` | 900 | each optional installer in `extras` |
| `--no-headless` | `DOTFILES_HEADLESS` | set to 1 | the Arch GUI/hardware blocks |
| `--keep-image` | — | rebuild | skips `docker build` |

Logs land in `make/test/logs/<distro>-<phase>.log`, with the image build captured
separately as `logs/<distro>-build.log` (both gitignored). `run.sh` exits with the number
of distros that reported failures — or 2 for a usage or preflight error, which is not a
distro count.

## Phases

| Phase  | Steps |
| ------ | ----- |
| `fast` | stage repo → `bash -n` over `make/` → shellcheck (advisory) → dispatch check → `make init` → `make test-symlinks` → repo-dirty check |
| `full` | the above, plus the whole installer end-to-end, an AppImage check, and `make test` as the oracle. **Termux is the exception**: it runs `install-termux.sh` directly under a 300s cap, because `make install` deliberately refuses Termux (see below). |
| `extras` | the fast steps, plus the six optional installers — `aws`, `gcp`, `azure`, `kubernetes`, `llm`, `tui` — which no `make install` path reaches and no `make test` assertion covers. Each gets `EXTRAS_TIMEOUT` seconds (default 900); override with `--extras-timeout`. |

Each step prints `##### STEP <name>` / `##### END <name> rc=<n>`, and the run ends with
a machine-readable block:

```
##### SUMMARY
stage_repo|0
syntax|0
...
##### FAILED=1 TOTAL=7
```

## Distros

| Image | Notes |
| ----- | ----- |
| `ubuntu:24.04` | The primary target. `$USER` is left unset on purpose — that is what verifies the `${USER:-$(id -un)}` guard. |
| `archlinux:base` | Needs `pacman-key --init` + `archlinux-keyring` or every `-S` fails signature checks. Run headless unless you want 10GB of GUI packages. |
| `amazonlinux:2023` | Verifies that EPEL is gone. It used to pin `epel-release-latest-7`, and deriving the major version does not help — `rpm -E %{rhel}` returns the literal string on AL2023 and AL2023 publishes no `epel-release` at all. What is left is an `amazon-linux-extras` probe that skips cleanly when absent. |
| `termux/termux-docker:x86_64` | Upstream's Termux CI image. Indicative only: no Android permissions model, no `termux-api`, `/system` is a stub. In the `full` phase it runs `install-termux.sh` rather than `make install`. |

macOS cannot be containerized; `make/mac/install-mac.sh` gets static review only.

## Design constraints

Each of these traces to a specific failure mode:

- **The repo must land at `$HOME/dotfiles`.** `install-init.sh` and `init.sh` hardcode
  that path and ignore where the checkout actually is.
- **Mount read-only, then copy.** `/staging` is `:ro`; the entrypoint `cp -a`s to
  `$HOME/dotfiles`. This started as a guard against two installers writing back into the
  repo — `git config --global` against the `.gitconfig` that `init.sh` had symlinked
  *into* the repo, and a rubygems tarball extracting into the CWD. Both are fixed (the
  `git config` calls were removed; rubygems now unpacks into a `mktemp -d` with an EXIT
  trap), but `install-termux.sh` still clones a second copy of the repo into the CWD, and
  the constraint is what proves the rest stay clean — hence the `repo_dirty` step.
- **Non-root with passwordless sudo.** There is no root fallback anywhere, and
  `makepkg` refuses to run as root at all.
- **No TTY, stdin from `/dev/null`, per-step `timeout`.** A missing `-y` must surface
  as a failure, not as a prompt someone can answer.
- **`2>&1` everywhere.** `log_error` writes to stderr, and so does `install_summary` —
  which means the failure ledger itself is lost from a stdout-only capture. Colors
  self-disable when stdout is not a TTY, so the logs are ANSI-free.
- **AppImage `nvim` cannot execute** without `--device /dev/fuse --cap-add SYS_ADMIN`.
  The harness verifies the payload with `--appimage-extract` instead of granting the
  container extra capabilities.

## Headless mode

`install-archlinux.sh` honours `DOTFILES_HEADLESS=1` (which `run.sh` sets by default) to
skip desktop applications, the display manager, sound/bluetooth/printing/power hardware,
GPU drivers, cuda and the ollama CUDA backend, qemu/virtualbox/wine, the GUI AUR packages,
GUI terminal emulators, input methods, `intel-ucode`, `meld` and the `zed` editor. Shells,
languages and CLI tooling still install; note that `zed` is the one editor on the skip
list, so "editors still install" is not quite true. Use it on servers and VM guests too,
not just in CI.

`make/test/FINDINGS.md` is the write-up of what running all this actually turned up —
per-distro results and the fixes each one forced.
