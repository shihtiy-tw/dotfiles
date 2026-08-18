# make/modules/ — shared installer code

Everything here is **sourced**, never executed. `common/*.sh` defines `install_<tool>`
functions that the per-distro installers call; `helpers/*.sh` provides the logging,
platform-detection and failure-ledger layer those functions are built on.

```text
modules/
├── helpers/
│   ├── logger.sh   # log_*, safe_exec, record_failure, record_unsupported,
│   │               #   install_summary, command_exists / dir_exists / file_exists
│   └── pkg.sh      # detect_platform, pkg_manager, detect_arch, as_root, can_root,
│                   #   pkg_install, ensure_cmds, setup_go_tls, user_bin_dir,
│                   #   install_binary
└── common/         # oh-my-zsh, nvm, rustup, autojump, tmux-tpm, gitflow, pyenv,
                    #   fzf, bun, agent-deck, vibe-kanban
```

## Conventions

These are not stylistic preferences. Each one exists because breaking it has already
caused a real failure.

### Use `MODULE_DIR`, never `SCRIPT_DIR`

A module resolves its own directory as:

```bash
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
```

`${BASH_SOURCE[0]}` rather than `$0` because the file is sourced, so `$0` is the
*caller's* path. And `MODULE_DIR` rather than `SCRIPT_DIR` because the callers use
`SCRIPT_DIR` for `make/` and source their modules by that name
(`install-ubuntu.sh:56-69`). When modules also assigned `SCRIPT_DIR`, the first
`source` overwrote it with `make/modules/common`, and every subsequent line in the
caller's list resolved to `make/modules/common/modules/common/<tool>.sh` — nonexistent.
With no `set -e` the failed sources were silent, so **only the first module in each list
ever loaded** and the run limped on until each `install_*` died with "command not found".
Renaming the variable is the entire fix; keep it renamed.

### Guard against double-sourcing

```bash
if [[ -n "${_NVM_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _NVM_MODULE_LOADED=1
```

`return`, not `exit` — this is a sourced file. Pick a unique name per module.

### Every step must reach the ledger

The installers deliberately do **not** use `set -e`: one unavailable package should not
abandon the other two hundred. That makes exit status meaningless unless steps report
themselves, so `logger.sh` keeps a tally and the installer ends with `install_summary`.
There are exactly three ways to report an outcome:

| Call | Use when | Effect on exit code |
| :--- | :--- | :--- |
| `safe_exec "desc" cmd args...` | the step is one command | fails → non-zero |
| `record_failure "desc"` | a multi-step block failed (clone-then-build, or a missing prerequisite that makes a later block skip itself) | fails → non-zero |
| `record_unsupported "desc" "reason"` | upstream publishes nothing usable for this platform | none — still exits 0 |

Calling `log_error` and nothing else is the bug to avoid. It looks like a report but
never reaches the tally: an Arch run once logged "yay installation failed", then "yay not
available, skipping AUR packages", and still finished with "All steps completed
successfully" and exit 0.

The `record_unsupported` third class exists because a two-outcome ledger scored "no
Android build exists" the same as "the install broke". On Termux that buried the one real
bug under five impossibilities. Reach for it only when there is genuinely nothing to
install, and always give the concrete reason — "its jiter dependency ships no Android
wheel and needs a Rust compiler", not "unavailable".

### Don't clobber the caller's namespace

Beyond `SCRIPT_DIR`, watch for variable names the tool you are installing uses itself.
`nvm.sh` carries a comment about exactly this: naming its version variable `NVM_VERSION`
and marking it `readonly` breaks nvm's own `local NVM_VERSION`, after which
`nvm install 20` silently resolves to the wrong thing. Prefix module globals, and avoid
`readonly` on anything a sourced third-party script might also declare.

### Prefer the helpers over raw commands

`pkg.sh` exists so modules stay distro-agnostic: `pkg_install` picks apt/pacman/dnf/pkg,
`detect_arch` normalises `uname -m` to the string the upstream download URL wants,
`as_root` works whether or not `sudo` is present, `install_binary` drops a binary into
`user_bin_dir` (which is `$PREFIX/bin` on Termux, `~/.local/bin` elsewhere), and
`setup_go_tls` fixes the missing CA bundle that otherwise breaks every Go `go install`
on Termux. Hardcoding `amd64` or `apt-get` in a `common/` module means it is not common.
