# Container audit of `make/` — findings

The per-OS installers had not been run end-to-end in a long time. They are almost pure
side effects (~238 `sudo` calls, ~40 network downloads, symlinking into `$HOME`), so they
were exercised inside throwaway containers for Ubuntu 24.04, Arch, Amazon Linux 2023 and
Termux. The harness that does this lives beside this file; see `README.md`.

Everything below was observed in a container run or reproduced locally, not inferred from
reading the code. Fixed items are listed for the record because most of them are invisible
on a machine that has already been provisioned by hand — which is why they survived so
long.

`mac/install-mac.sh` was reviewed statically only. macOS cannot be containerised, so
nothing here is verified for it.

---

## Where things stand

Both columns are full `make install` → `make init` → `make test` runs in a fresh container.
"Before" is the state the scripts were in when the audit started; "after" is the same
harness re-run against the fixes.

| | Before | After |
| --- | --- | --- |
| **Ubuntu 24.04** | installer died at line 331 of 480; 3 of 10 harness steps failed; 43 pass / 11 fail | installer runs to the end: 58 steps completed, 1 failed (yazi, fixed after this run); **52 pass / 2 fail** |
| **Arch** | 1 of 10 failed; yay build broken so every AUR package skipped, while the run reported success; 53 pass / 0 fail | 0 of 10 failed; yay builds, 90 steps completed, 0 failed; **53 pass / 0 fail** |
| **Amazon Linux 2023** | 2 of 10 failed; pip, ripgrep and diff-so-fancy could not install; 32 pass / 3 fail | installer exits 0 and means it: 32 steps completed, 0 failed; **34 pass / 1 fail** |
| **Termux** | `make install` printed three `/etc/os-release` errors and exited 0 having done nothing | dispatcher refuses with exit 1 and a clear message; 13 of 13 symlinks valid; **0 fail** |

Of the three failures left in that column, two are the same test — `neovim (nvim) runs`,
on Ubuntu and Amazon Linux — and it is an artifact of the container rather than a defect:
those two install Neovim as an AppImage, which needs FUSE to self-mount, and the containers
are deliberately run without `--device /dev/fuse`. The test is right to fail — on a real
machine without FUSE `nvim` genuinely would not start, and you would want to know — so it
was left alone. The harness carries a separate `appimage_check` step that unpacks the image
with `--appimage-extract` and runs the binary directly; it passes on both. The third,
Ubuntu's `yazi`, was a real breakage; it was fixed after this run and verified in its own
container. `docker group membership` is skipped rather than failed for the same
container-artifact reason — it needs a fresh login session.

Neither the `modules/common/modules/common/…` path errors from the `SCRIPT_DIR` collision
nor any repo-dirtying appear in any of the four logs: `repo_dirty` reports "repo copy is
clean" everywhere.

---

## Fixed

### Cross-platform

| What | Why it mattered |
| --- | --- |
| `modules/common/nvm.sh` — `readonly NVM_VERSION` | The worst bug found. `nvm.sh` is sourced into the *same* shell and uses `NVM_VERSION` as a function-local while resolving versions, so a `readonly` global of that name made nvm's `local NVM_VERSION` fail. `nvm install 20` then silently resolved to whatever node was already on `PATH` **and still reported success**. Renamed to `NVM_INSTALLER_VERSION`, dropped `readonly`, and `install_node` now checks the active version rather than trusting nvm's exit status. |
| `modules/common/fzf.sh` — `yes \| ./install` | The installers run with `set -o pipefail`. When `./install` exits, `yes` dies of `SIGPIPE`, the pipeline adopts status 141, and a perfectly good fzf install was reported as a failure. Now uses the installer's own non-interactive flags. |
| `modules/helpers/logger.sh` — no failure aggregation | `make install` exited 0 no matter what. A run with ten broken steps was indistinguishable from a clean one, so it could never be used as a gate. `safe_exec` now records failures and `install_summary` turns the tally into an exit code; all three installers end with it. |
| `install-init.sh` — no `else`, unguarded `/etc/os-release` | Every Linux arm `cat`-ed `/etc/os-release`. On Termux that file does not exist, so `make install` printed three "No such file or directory" lines, fell off the end of the `if`/`elif` chain, and **exited 0 having installed nothing**. Same silent success on Debian, Fedora and Manjaro. Now guarded, with an explicit failure for unsupported platforms. |
| `envfile`, `zsh/env.zsh` — `GOPATH=/usr/local/go` | That path is `GOROOT`, not a workspace. Every non-root `go install` died trying to create a module cache inside a root-owned tree. |
| `Makefile` — `/usr/bin/git` | Termux's git is under `$PREFIX/bin`. |
| `install-termux.sh`, `install-llm.sh`, `install-tui.sh` mode bits | Committed `0644`; `install-termux.sh` failed with rc=126. |
| `modules/common/gitflow.sh` — installer URL | The gitflow-cjs raw URL is a permanent 404 (`contrib/` no longer exists there). Probed both: gitflow-avh returns 200. Also switched to `curl` — Amazon Linux 2023 ships no `wget` — and added a `$HOME/.local` prefix fallback for when there is no sudo. |
| `--prefix "$HOME/.local"` on `npm install -g` | When npm comes from a distro package its global prefix is `/usr`, so `npm i -g` `EACCES`-es for any non-root user. |
| `modules/common/autojump.sh` — `load_autojump` under `set -u` | **The most damaging bug of the whole audit.** autojump's own `autojump.bash` reads `$XDG_DATA_HOME` with no default. Sourcing that from an installer running `set -u` is a *fatal* shell error, not a non-zero return — so `load_autojump \|\| true` at `install-ubuntu.sh:331` could not catch it, and the script died there, at line 331 of 480. Everything below that point had **never been installed on a fresh machine**: silversearcher, docker, imagemagick, mainline, gcc-14, tig, gh, terraform, packer, agent-deck and vibe-kanban. `install_summary` never ran either, so the whole thing surfaced as one cryptic line about an unbound variable. Nine of Ubuntu's eleven test failures traced back here. |
| `modules/common/gitflow.sh` — clone left in `$PWD` | The AVH installer git-clones into its working directory. Run from the repo, which is where `make install` runs, it left an untracked `gitflow/` behind on Ubuntu and Arch. Now runs in a `mktemp -d`. |
| `envfile` — `GOROOT := /usr/local/go` | `Makefile:3` exports every name in `envfile` into every recipe's environment, so this overrode the `GOROOT` each Go toolchain has compiled in. On Arch, where Go lives in `/usr/lib/go`, the yay build inside `make install` died with `go: cannot find GOROOT directory: /usr/local/go` — no AUR helper, so every AUR package was skipped for the rest of the run. Setting `GOPATH` is enough; `GOROOT` must not be set. |
| `Makefile` — `@echo` with `\033`/`\n` throughout | `make` runs recipes under `/bin/sh`, and where that is bash the builtin `echo` does not interpret backslash escapes, so `help`, `hello`, `install`, `init`, `dark`, `light` and all seven test targets printed their escapes literally. Converted to `printf '%b\n'`. |
| `envtest.sh` — no shebang, duplicated lines | Not executable as a script (the only shellcheck error left in `make/`), and its first three lines were the same `echo ${ZSHRCPATH}` while `ZSHRCBACKUPPATH` went unprinted. Shebang added, duplicates removed, expansions quoted, mode `0755`. Same duplicate fixed in the Makefile's `env` target. |
| `envfile` — values wrapped in literal `"` | `ZSHRCPATH = "${HOME}/.zshrc"` put the quote *characters* into the exported value, so `$ZSHRCPATH` named a file that cannot exist. Nothing consumes these today beyond the `env` diagnostic, which is the only reason it never bit — but it is a loaded gun for the next person who writes `rm "$ZSHRCPATH"`. Quotes removed; make does not need them. |
| `logger.sh` — new `record_failure` | Steps that are a clone-then-build, or that skip a later block, could not be expressed as one `safe_exec` command, so they called `log_error` and never reached the ledger. Arch logged "yay installation failed", then "yay not available, skipping AUR packages", then **"All steps completed successfully"** and exited 0. |

### Ubuntu

- **`DEBIAN_FRONTEND` never reached apt.** `export DEBIAN_FRONTEND=noninteractive` is
  stripped by sudo's `env_reset` before apt sees it — debconf still reported "unable to
  initialize frontend: Dialog" and the run only survived because there was no terminal to
  draw on. Fixed with a `sudo` wrapper using `sudo env VAR=...`; `sudo -E` and
  `sudo VAR=val cmd` were both rejected because they need the `SETENV` sudoers tag, which
  a stock `%sudo ALL=(ALL:ALL) ALL` does not grant.
- **`add-apt-repository` was not installed yet.** `software-properties-common` was
  installed *after* the two PPAs that need it, so both failed with "command not found"
  and `mainline` was never installed.
- **Neovim installed a 404 page as the editor.** Upstream renamed the asset to include the
  architecture, and `curl -LO` without `-f` exited 0 having written the 9-byte "Not Found"
  body to `/usr/local/bin/nvim`, execute bit and all.
- **RubyGems dirtied the repo.** It extracted into `$PWD` (the checkout, under
  `make install`), then `cd "$HOME"` ran *before* the cleanup, so the tarball and
  extracted directory were left behind as untracked files. `ruby setup.rb` also needs root
  to write `/usr/local/lib/site_ruby`, and success was logged unconditionally.
- **yazi had no working `cargo install` path at all** — it took three container runs to
  establish that. `yazi-fm`/`yazi-cli` abort in `build.rs` demanding
  `cargo install --force yazi-build`, after ~2.5 minutes of compilation, and have not been
  published since 26.5.6 (`yazi-build` is at 26.8.15). But `yazi-build` is only the build
  *system*: the one executable it puts in `~/.cargo/bin` is `yazi-build` itself, so that
  step reported success while leaving no `yazi` on the machine. Running it does not help
  either — it shells out to `cargo --config .cargo/release.toml` inside the crates.io
  registry source directory, where no such file exists, because it is written to run from a
  checkout of the yazi repo. `--config` accepts either a path or a dotted key=value, so a
  missing file is not reported as missing; cargo tries to parse the path as TOML and dies
  with `failed to parse value from --config argument`. Now installed from the upstream
  release archive, like Go, Neovim and ripgrep elsewhere in these scripts, which also skips
  the Rust build. `ya` goes with it, since upstream ships them as a pair.
- **`gh`, `terraform` and `packer` were installed by bare `&&` chains** that never reached
  the failure ledger, so a machine that ended up with none of the three still reported a
  successful run. Now wrapped in functions and passed to `safe_exec`. Packer also dropped
  its duplicate repository setup, which used `apt-key add` — removed in Ubuntu 24.04 — and
  hardcoded `arch=amd64`; it comes from the HashiCorp repo the terraform block just added.
- **`diff-so-fancy` scraped its version out of the GitHub API into an unquoted variable**,
  so a rate limit produced the URL `.../download/v/diff-so-fancy`, and `curl -L` without
  `-f` writes the 404 body to the destination and exits 0 — the same defect as the Neovim
  one, one API hiccup away from installing an HTML error page as an executable.
  `/releases/latest/download/` needs no scraping.
- **`pipx`, `manim` and `git-sim`** were likewise raw commands outside the ledger.
- **Two `git config --global` writes were pointless.** `git/gitconfig` already carries
  `commit.template` and `core.editor`, and `make init` symlinks `~/.gitconfig` to it, so
  the writes only got backed up and replaced. The `core.editor` line was also malformed
  and just printed usage.

### Arch

- **`yay <pkg>` without `-S` is interactive *search*.** It prints a numbered hit list and
  waits for numbers; `yes` feeds `y`, not a number, so yay printed "there is nothing to
  do" and **exited 0 having installed nothing**. Replaced with an `aur_install` helper
  using `-S --noconfirm` plus the `--answer*` flags.
- **`zsh` was never installed** by the Arch installer at all, despite the whole repo being
  a zsh configuration. `git-lfs` was missing too.
- **`DOTFILES_HEADLESS=1` gate added** around the GUI and hardware blocks (firefox,
  libreoffice, gimp, obs-studio, cuda, nvidia-utils, virtualbox-host-dkms, wine, fcitx5,
  ghostty/kitty, zed, meld). That is >10 GB and hours of build time that a headless
  machine cannot use. This is a deliberate behaviour change, opt-in via the variable.
- **yay failed to build, then reported success anyway.** `log_success "yay installed"` sat
  one line below the failure branch and ran unconditionally, and the failure went only to
  `log_error`, so nothing reached the ledger. Every AUR package for the rest of the run was
  then skipped with a warning while `make install` exited 0. (The build failure itself was
  the `GOROOT` bug above.) `/tmp/yay` is also now removed *before* the clone — makepkg
  refuses to build in a leftover directory, so a second attempt failed for a different
  reason than the first.
- **Failed AUR packages are recorded, not just warned.** The call site keeps `|| true` so
  one broken package does not abandon the rest, but the run now admits the environment came
  out incomplete.
- Every pacman package name was mechanically verified as still valid: zero
  `target not found` across 87 install groups.

### Amazon Linux 2023

- **The entire Python block was dead code.** It was wrapped in
  `if [ "$HOME" = "/root" ]`, so for every ordinary user `python3-pip` was never installed
  and every later `pip3` call failed with "command not found".
- **EPEL could never work.** It was pinned to the el7 rpm; deriving the version does not
  help either, because `rpm -E %{rhel}` returns the literal string `%{rhel}` on Amazon
  Linux and AL2023 publishes no `epel-release` package at all. The EPEL attempt was
  removed, and `the_silver_searcher` (EPEL-only) replaced with `ripgrep`.
- **A failed Neovim download deleted a working nvim.** `sudo rm -f /usr/bin/nvim` ran
  *before* the download, so a failure left the machine with no editor at all. Now
  downloads to a temp dir and installs only on success.
- **`libatomic` and `wget` were missing.** Node's official linux-x64 build links against
  `libatomic.so.1`, which AL2023 does not install by default — without it nvm's node
  cannot execute at all, taking node, npm and vibe-kanban with it. AL2023 also ships only
  `curl-minimal`, so two `wget` calls died with "command not found" outside `safe_exec`,
  and the log claimed success for tools that were never downloaded.
- **`install_pyenv` was sourced but never called**, which also left the Python build
  dependencies with nothing to build.
- **`'python3*'` could never install anything, quoted or not.** The unquoted glob was
  expanded by the shell against the current directory before yum saw it — but quoting it
  only revealed the real problem: on AL2023 the pattern matches several hundred packages
  including mutually exclusive ones (`python3-perf6.18` vs `python3-perf`, `python3-pytest4`
  vs `python3-pytest`), and dnf aborts the entire transaction on the conflict rather than
  choosing. So **pip was never installed either way**. Replaced with the packages actually
  needed: `python3 python3-pip python3-devel python3-setuptools python3-wheel`.
- **ripgrep is not in the AL2023 repos.** `the_silver_searcher` is EPEL-only, so it had been
  swapped for ripgrep — but `yum install ripgrep` fails with `No match for argument:
  ripgrep`. Now installs the upstream static build (musl on x86_64, gnu on aarch64), the
  same way this file already handles Go and the Neovim AppImage.
- **The `diff-so-fancy` URL was a 404 on every branch.** It fetched
  `third_party/build_fatpack/diff-so-fancy`; upstream's default branch is `next` and that
  directory is not in the tree. The release asset is the fatpacked self-contained script.

### Test oracles

These were reporting failures for tools that were installed and working, which is worse
than no test at all.

- **`test-install.sh` had no platform scope.** Amazon Linux reported 21 failures for tools
  its installer never attempts, and Termux failed 57 of 61. Every assertion is now scoped
  to the platforms whose installer actually provides the tool, and skips are counted
  separately from passes so the coverage gap still shows.
- **`PATH` and `nvm` were not set up before asserting.** The suite runs under bash but the
  tools are put on `PATH` by `zsh/env.zsh`; and `~/.cargo/env` was sourced in
  `test_cargo_packages`, which runs *after* the Rust assertions. `nvm.sh` was sourced but
  no version selected, so `node` and `npm` were absent. That was 5 false failures per
  distro (`rustc`, `cargo`, `rustup`, `node`, `npm`).
- **`command -v nvim` passed the 9-byte 404 body** described above. Now asserts
  `nvim --version` actually runs.
- **`docker` was tested twice and docker-compose never.**
- **The `lua || luarocks` fallback could not work**: the first `run_test` had already
  printed FAIL and incremented the counter, so the `||` added a second result instead of
  replacing the first. Replaced with `test_any_command`.
- **`pyenv` was asserted at `~/.pyenv`**, but Arch installs the pacman package at
  `/usr/bin/pyenv`. Now accepts either.
- **The docker-group check could never pass in a container** (group membership needs a new
  login session). Now SKIP rather than FAIL, since it is unverifiable rather than wrong.
- **`test-symlinks.sh` omitted `alacritty.yml`**, which `init.sh` has always linked — so
  a missing or wrong link went unreported on every platform.
- **The spaceship theme was asserted unconditionally**, but `init.sh` only links it when
  the `spaceship-prompt` clone exists. This was the *only* failing check on all four
  distros in the fast phase — a guaranteed false negative. Moved to a conditional list.
- **`~`-shortening in the report was a silent no-op.** In `${p/#$HOME/~}` the `~` in the
  replacement position is tilde-expanded back to `$HOME`, so every line printed the full
  `/home/<user>` path. Needs `\~`, and `$DOTFILES_DIR` has to be substituted before
  `$HOME` because the checkout lives underneath it.
- **`make help` printed literal `\033[0;36m` and `\n`.** make runs recipes under
  `/bin/sh`; where that is bash, the builtin `echo` does not interpret backslash escapes.
  Switched to `printf '%b\n'`.

### Harness bugs (in this directory)

- `Dockerfile.termux` needs `USER 1000`: the base image declares no `USER`, so `RUN` runs
  as root and `pkg` refuses that outright. It is also needed at run time, because our
  `ENTRYPOINT` replaces the base image's privilege-dropping `/entrypoint.sh`.
- `Dockerfile.termux` now preloads `libtermux-exec.so`. Termux has no `/bin`,
  `/usr/bin/env` or `/tmp`, so `#!/bin/bash` cannot be resolved by the kernel; on a real
  device the termux-exec shim rewrites those paths into `$PREFIX` as `execve()` is called.
  The image ships the library but does not set `LD_PRELOAD`, so without it the harness
  invented "bad interpreter" failures with no counterpart on hardware. It must be
  inherited by the *calling* shell — the interception happens in the process invoking
  `execve()`, before the new program image exists.
- The dispatch step now asserts that an unsupported platform **fails**, rather than
  requiring a matching arm.
- A comment claiming `install-termux.sh` hangs without a TTY was wrong: measured rc=0 in
  ~35s. The real defect is that a wholly ineffective run reports success.

---

## Not fixed — needs a decision

These are design choices rather than defects, so they are reported rather than changed.

### 1. Termux is not supported, and saying so is now explicit

`install-termux.sh` cannot work as written, and wiring it into the dispatcher would make
things worse rather than better:

- `:10` clones a **second copy** of the repo into whatever the CWD happens to be, before
  its own `cd "$HOME"` on `:13` — discarding the checkout the user is running from.
- It never calls `init.sh`, so it links no configs at all. The single highest-value
  missing line is `bash "$DOTFILES/make/init.sh"`.
- It never sources `make/modules/`.
- It ends by installing `termux-style`, whose menu is interactive.
- `bun` is not packaged for Termux; `pkg install nodejs-lts` and skipping nvm would be
  the equivalent.

`init.sh` itself *does* work correctly on Termux — that was verified. So the dispatcher
now tells Termux users to run `bash make/init.sh` directly and exits non-zero, instead of
silently succeeding. Rewriting the installer properly is a separate piece of work.

Note that if Termux support is added, dispatch must invoke installers as
`bash "$script"` rather than relying on shebangs: `#!/usr/bin/env bash` does not work
there either, because `/usr/bin/env` is also absent.

### 2. `install-kubernetes.sh` never downloads kubectl

`:26` runs `chmod +x ./kubectl` and `:27` copies it to `$HOME/bin/kubectl`, but nothing
ever downloads the binary — the `curl` for it is simply missing. Additionally, `:14-19`
correctly detects the architecture and then `:32` overwrites it with a hardcoded
`ARCH=amd64`, so the eksctl download is wrong on arm64. This script is not reachable from
any `make` target, so it was left alone; note the `# TODO: add aws and kubernetes script`
in the Makefile. (The other `amd64` hardcode, in Ubuntu's packer block, is gone — that
block no longer adds a repository at all.)

### 3. Ubuntu's tool list has gaps the oracle now records as out-of-scope

- `htop` is never installed on Ubuntu or Amazon Linux (only Arch installs it).
- `vim` is commented out at `install-ubuntu.sh:258`. Arch installs `vi`, not `vim`.
- `fcitx5` is installed ungated at `:134`, unlike Arch where it now sits behind
  `DOTFILES_HEADLESS`. An input method framework is not useful on a headless box.

The oracle now scopes these per platform rather than reporting a wishlist item as a
regression. Whether to install them is your call.

### 4. Arch deliberately diverges on Rust and pyenv

`install-archlinux.sh` sources neither `modules/common/rustup.sh` nor `pyenv.sh`; it
installs the pacman `rust` and `pyenv` packages instead. That is a reasonable choice on
Arch, but it means `rustup` is absent there and `pyenv` lives at `/usr/bin/pyenv` rather
than `~/.pyenv`. The oracle now encodes this. Worth confirming it is intentional.

### 5. Smaller things

- `make/envfile` is only used for the `env`/`remove_env` targets and the variables it
  defines largely duplicate what `init.sh` computes.
- `Makefile:53-63` is a commented-out older copy of the `help` text that mentions an
  `rm_env` target; the live target is `remove_env`. Dead comment, no user impact.
- AppImage `nvim` cannot execute in a container without `--device /dev/fuse` and
  `--cap-add SYS_ADMIN`. The harness verifies via `--appimage-extract` rather than
  granting containers extra capability, so treat container nvim results accordingly.

---

## Things that were checked and found fine

Worth recording so they are not re-investigated:

- The `SCRIPT_DIR` → `MODULE_DIR` rename holds on all four platforms: zero
  `modules/common/modules/common/...` paths, and every `install_*` function actually runs.
- The `${USER:-$(id -un)}` guard survives `set -u` with `$USER` unset.
- The read-only `/staging` mount held. Once the RubyGems bug was fixed, no installer
  wrote back into the repo on any platform.
- Arch's headless gate was verified mechanically by diffing every `safe_exec "<label>"`
  against every `Completed: <label>` — all 39 non-running labels were inside gated blocks.
- An earlier claim that `zsh/env.zsh` never adds `~/.cargo/bin`, `~/.bun/bin` or
  `~/.local/bin` was **wrong**: it adds all three. The symptom was an artefact of the test
  suite running under bash. Only two genuine gaps existed there (the `GOPATH`/`GOROOT`
  conflation, and `~/.fzf/bin`).
