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

./make/test/run.sh --phase fast ubuntu
./make/test/run.sh --phase full archlinux --no-headless   # include the ~10GB of GUI packages
./make/test/run.sh --phase extras ubuntu                  # the optional tool sets only
./make/test/run.sh --keep-image ubuntu                    # skip the image rebuild
```

Logs land in `make/test/logs/<distro>-<phase>.log` (gitignored). `run.sh` exits with
the number of distros that reported failures.

## Phases

| Phase  | Steps |
| ------ | ----- |
| `fast` | stage repo → `bash -n` over `make/` → shellcheck (advisory) → dispatch check → `make init` → `make test-symlinks` → repo-dirty check |
| `full` | the above, plus the whole installer end-to-end, an AppImage check, and `make test` as the oracle |
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
| `amazonlinux:2023` | el9, so it exercises the EPEL major-version detection that replaced the hardcoded el7 rpm. |
| `termux/termux-docker:x86_64` | Upstream's Termux CI image. Indicative only: no Android permissions model, no `termux-api`, `/system` is a stub. |

macOS cannot be containerized; `make/mac/install-mac.sh` gets static review only.

## Design constraints

Each of these traces to a specific failure mode:

- **The repo must land at `$HOME/dotfiles`.** `install-init.sh` and `init.sh` hardcode
  that path and ignore where the checkout actually is.
- **Mount read-only, then copy.** The installers write into the repo — `git config
  --global` against the `.gitconfig` that `init.sh` symlinked *into* the repo, and the
  rubygems tarball extracts into the CWD. `/staging` is `:ro`; the entrypoint `cp -a`s
  to `$HOME/dotfiles`.
- **Non-root with passwordless sudo.** There is no root fallback anywhere, and
  `makepkg` refuses to run as root at all.
- **No TTY, stdin from `/dev/null`, per-step `timeout`.** A missing `-y` must surface
  as a failure, not as a prompt someone can answer.
- **`2>&1` everywhere.** `log_error` is the only logger function that writes to stderr.
  Colors self-disable when stdout is not a TTY, so the logs are ANSI-free.
- **AppImage `nvim` cannot execute** without `--device /dev/fuse --cap-add SYS_ADMIN`.
  The harness verifies the payload with `--appimage-extract` instead of granting the
  container extra capabilities.

## Headless mode

`install-archlinux.sh` honours `DOTFILES_HEADLESS=1` (which `run.sh` sets by default)
to skip desktop applications, the display manager, sound/bluetooth/printing/power
hardware, GPU drivers, cuda, qemu/virtualbox/wine, and the GUI AUR packages. Shells,
editors, languages and CLI tooling still install. Use it on servers and VM guests too,
not just in CI.
