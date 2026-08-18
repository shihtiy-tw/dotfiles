# make/mac/ — macOS installer

Reached by `make install` when `uname` is `Darwin` (`install-init.sh:43-46`).

```text
mac/
├── install-mac.sh          # the installer
├── Brewfile.arm            # Apple Silicon package set (63 lines)
├── Brewfile.x86            # Intel package set (60 lines)
├── ToggleDarkMode.scpt
└── theme/
    ├── ToggleDarkMode.app.scpt
    ├── Afterglow.itermcolors
    ├── gruvbox.itermcolors
    └── material-design-colors.itermcolors
```

## Status: unverified

**This is the one installer in the repo that has never been run end to end by the
container harness, and it cannot be.** macOS cannot be containerized on Linux, and there
is no Mac in the loop, so `make/test/` covers Ubuntu, Arch, Amazon Linux and Termux and
leaves this file to static review only. Everything below came from reading the script, not
from executing it. Treat it accordingly: the last dated change in its header is
2026-02-01.

Two things were checked and are fine. It sources the shared modules by
`$SCRIPT_DIR/../modules/...` (`:21-32`), which works now that the modules use `MODULE_DIR`
instead of clobbering `SCRIPT_DIR` — see [../modules/README.md](../modules/README.md). And
`brew bundle --file Brewfile.arm` (`:70`, `:77`) is a *relative* path, but `:65` does
`cd "$SCRIPT_DIR"` first, so it resolves.

## Known gap: no failure ledger

`install-mac.sh` calls `safe_exec` exactly **once** in 201 lines (`:149`, rbenv) and never
calls `install_summary`. It ends with a `log_success` and some next-step echoes, so it
exits 0 no matter what broke. For comparison, after the audit:

| Installer | `safe_exec` | `record_failure` | `install_summary` |
| :--- | ---: | ---: | ---: |
| `install-ubuntu.sh` | 59 | 5 | yes |
| `install-archlinux.sh` | 142 | 2 | yes |
| `install-amazon-linux.sh` | 36 | 11 | yes |
| `mac/install-mac.sh` | 1 | 0 | **no** |

This is the same defect the Linux installers were fixed for — a run with ten broken steps
reports success and no automation can tell it from a clean one. Wrapping the steps in
`safe_exec` and ending with `install_summary` is mechanical work; it is left undone here
only because there is no way to verify the result from this machine. Anyone with a Mac
should do that pass and actually run it.

## Architecture split

`uname -m` picks the Brewfile (`:67-80`) and also the Homebrew prefix after a fresh
install (`:45`) — `/opt/homebrew` on arm64, `/usr/local` on Intel. If a Brewfile is
missing the script only logs a warning and carries on, installing none of that set.

## Theming

`make dark` / `make light` do not use `ToggleDarkMode.scpt`. `color-theme.sh` talks to
System Events via `osascript` directly (`color-theme.sh:49` notes this is what the script
does internally, but setting the value explicitly is idempotent whereas the script
toggles). The `.itermcolors` files are for iTerm2 and are not referenced by any script —
import them by hand if you use iTerm2. On macOS, `tmux-dark-notify` is what makes tmux
follow the OS mode; on Linux that job belongs to `darkman`.
