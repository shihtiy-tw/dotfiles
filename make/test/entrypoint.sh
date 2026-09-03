#!/usr/bin/env bash
################################################################################
# Container test entrypoint - runs INSIDE a throwaway container.
#
# Never run this on a real machine. The `full` phase executes the distro
# installer, which removes container runtimes, adds kernel PPAs, and overwrites
# ~/.zshrc, ~/.gitconfig, ~/.aws/config and ~/.config/nvim/*.
#
# Inputs (environment):
#   PHASE            fast | full | extras (default: fast)
#   DISTRO           label for the report (default: derived from /etc/os-release)
#   STAGING          read-only repo mount (default: /staging)
#   INSTALL_TIMEOUT  seconds for the installer step (default: 3600)
#   EXTRAS_TIMEOUT   seconds for each optional installer (default: 900)
#
# Output: a human log plus a machine-readable ##### SUMMARY block.
# Exit code: number of failed steps (0 = everything passed).
################################################################################

set -u

PHASE="${PHASE:-fast}"
STAGING="${STAGING:-/staging}"
INSTALL_TIMEOUT="${INSTALL_TIMEOUT:-3600}"
EXTRAS_TIMEOUT="${EXTRAS_TIMEOUT:-900}"
DOTFILES="$HOME/dotfiles"

if [ -z "${DISTRO:-}" ]; then
    DISTRO="$( (grep -m1 '^ID=' /etc/os-release 2>/dev/null || echo 'ID=unknown') \
        | cut -d= -f2 | tr -d '"' )"
fi

STEP_NAMES=()
STEP_CODES=()

run_step() {
    local name="$1"
    shift
    local start=$SECONDS
    local rc=0

    printf '\n##### STEP %s\n' "$name"
    "$@" </dev/null 2>&1 || rc=$?
    printf '##### END %s rc=%s elapsed=%ss\n' "$name" "$rc" "$((SECONDS - start))"

    STEP_NAMES+=("$name")
    STEP_CODES+=("$rc")
    return "$rc"
}

################################################################################
# STEPS
################################################################################

# The installers write into the repo (rubygems tarball, git config --global against
# the symlinked .gitconfig, nested clones), so the mount stays read-only and we work
# on a copy. $HOME/dotfiles is not negotiable: install-init.sh and init.sh hardcode it.
step_stage_repo() {
    if [ ! -d "$STAGING" ]; then
        echo "staging mount $STAGING is missing" >&2
        return 1
    fi
    rm -rf "$DOTFILES"
    mkdir -p "$DOTFILES"
    cp -a "$STAGING/." "$DOTFILES/" || return 1
    # A worktree checkout has .git as a file pointing outside the mount; that would
    # make every later git call fail confusingly. Drop it and re-init a standalone
    # repo so the dirty-check step still works.
    if [ -f "$DOTFILES/.git" ]; then
        rm -f "$DOTFILES/.git"
        git -C "$DOTFILES" init -q 2>/dev/null || true
        git -C "$DOTFILES" add -A 2>/dev/null || true
        git -C "$DOTFILES" -c user.email=test@local -c user.name=test \
            commit -qm baseline 2>/dev/null || true
    fi
    echo "staged $(find "$DOTFILES" -type f | wc -l) files at $DOTFILES"
    echo "whoami=$(id -un) uid=$(id -u) HOME=$HOME USER=${USER:-<unset>}"
}

step_syntax() {
    local rc=0 f
    while IFS= read -r f; do
        if ! bash -n "$f"; then
            echo "SYNTAX FAIL: $f"
            rc=1
        fi
    done < <(find "$DOTFILES/make" -name '*.sh' -type f | sort)
    [ "$rc" -eq 0 ] && echo "all make/*.sh parse cleanly"
    return "$rc"
}

# Non-gating: shellcheck is unavailable on some of these images and its style
# warnings are not the thing under test.
step_shellcheck() {
    if ! command -v shellcheck >/dev/null 2>&1; then
        echo "shellcheck not installed on this image - skipped"
        return 0
    fi
    shellcheck --severity=error --shell=bash "$DOTFILES"/make/*.sh \
        "$DOTFILES"/make/modules/*/*.sh || true
    echo "(shellcheck output above is advisory)"
}

# install-init.sh has no else branch, so a distro it does not match makes
# `make install` exit 0 having installed nothing. Check the match, don't install.
step_dispatch() {
    local id expected
    id="$( (grep -m1 '^ID=' /etc/os-release 2>/dev/null || true) | cut -d= -f2 | tr -d '"' )"
    echo "/etc/os-release ID=${id:-<none>}"

    case "$id" in
        ubuntu | linuxmint) expected=install-ubuntu.sh ;;
        amzn)               expected=install-amazon-linux.sh ;;
        arch)               expected=install-archlinux.sh ;;
        *)                  expected="" ;;
    esac

    if [ -n "$expected" ]; then
        # Checked statically rather than by running it: on a supported distro the
        # dispatcher's whole job is to exec the installer, which is what the `install`
        # step is for.
        if grep -q "$expected" "$DOTFILES/make/install-init.sh"; then
            echo "dispatches to $expected"
            return 0
        fi
        echo "install-init.sh does not reference $expected"
        return 1
    fi

    # Unsupported platform (Termux, or any distro with no arm). The requirement here is
    # not that an installer runs - it is that `make install` REFUSES, loudly. It used to
    # print three "cat: /etc/os-release: No such file or directory" lines, fall off the
    # end of the if/elif chain and exit 0, so an unsupported OS reported a successful
    # provisioning run having installed precisely nothing.
    #
    # Safe to actually execute: every path that reaches this point exits before touching
    # the system.
    echo "no dispatch arm for ID=${id:-<none>} - checking that it fails loudly"
    local out rc=0
    out="$(bash "$DOTFILES/make/install-init.sh" 2>&1)" || rc=$?
    echo "$out" | sed 's/^/    /'

    if [ "$rc" -eq 0 ]; then
        echo "REGRESSION: install-init.sh exited 0 on an unsupported platform"
        return 1
    fi
    echo "correctly refused with exit $rc"
    return 0
}

step_install() {
    echo "running 'make install' with a ${INSTALL_TIMEOUT}s cap"
    if command -v timeout >/dev/null 2>&1; then
        timeout --signal=TERM --kill-after=30 "$INSTALL_TIMEOUT" \
            make -C "$DOTFILES" install
    else
        make -C "$DOTFILES" install
    fi
}

step_init() {
    make -C "$DOTFILES" init
}

step_symlinks() {
    make -C "$DOTFILES" test-symlinks
}

step_make_test() {
    make -C "$DOTFILES" test
}

# Proves the read-only mount held and shows what the installers wrote back into the
# repo copy. Non-empty output is a finding, not necessarily a failure.
step_repo_dirty() {
    if ! git -C "$DOTFILES" rev-parse --git-dir >/dev/null 2>&1; then
        echo "no git metadata in the staged copy - skipped"
        return 0
    fi
    local out
    out="$(git -C "$DOTFILES" status --porcelain)"
    if [ -n "$out" ]; then
        echo "the installers modified the repo copy:"
        echo "$out"
        return 1
    fi
    echo "repo copy is clean"
}

# Termux never reaches the module system: install-termux.sh clones a *second* copy of
# the repo into whatever the CWD happens to be (line 10, before its own `cd "$HOME"`),
# never sources make/modules, and never calls init.sh - so it links no configs at all.
#
# It does NOT hang, which is what an earlier version of this comment claimed. Measured
# in this container: termux-style's ./install reads its menu from stdin, gets EOF
# immediately with stdin at /dev/null, and exits 0 in about 35 seconds. The timeout
# below stays as a guard against that changing upstream, not as an expected outcome.
# The real defect is that a wholly ineffective run reports success.
step_termux_installer() {
    echo "running install-termux.sh under a 300s cap"
    if command -v timeout >/dev/null 2>&1; then
        timeout --signal=TERM --kill-after=15 300 "$DOTFILES/make/install-termux.sh"
    else
        "$DOTFILES/make/install-termux.sh"
    fi
}

step_appimage_check() {
    if ! command -v nvim >/dev/null 2>&1; then
        echo "nvim not on PATH - nothing to verify"
        return 0
    fi
    if nvim --version >/dev/null 2>&1; then
        echo "nvim executes: $(nvim --version | head -1)"
        return 0
    fi
    # Expected without --device /dev/fuse; extract instead of granting the container
    # SYS_ADMIN just to satisfy a smoke test.
    echo "nvim will not run (no FUSE in container) - trying --appimage-extract"
    local d
    d="$(mktemp -d)"
    if (cd "$d" && "$(command -v nvim)" --appimage-extract >/dev/null 2>&1 \
        && ./squashfs-root/usr/bin/nvim --version | head -1); then
        echo "AppImage payload is intact (FUSE-only failure, container artifact)"
        rm -rf "$d"
        return 0
    fi
    rm -rf "$d"
    echo "nvim is neither executable nor a valid AppImage"
    return 1
}

# Run one of the optional tool installers (install-aws.sh, install-gcp.sh, ...).
#
# These are not reachable from `make install` - they are opt-in tool sets - so nothing in
# the fast or full phase ever executed them, which is exactly why they accumulated the
# most rot in the repo: a missing kubectl download, an apt-only helm block, a `pacman` call
# in the generic TUI script, and an `npx <github url>` that launched an interactive CLI
# instead of installing anything.
step_optional() {
    local script="$1"

    if [ ! -f "$DOTFILES/make/$script" ]; then
        echo "$script does not exist" >&2
        return 1
    fi
    if [ ! -x "$DOTFILES/make/$script" ]; then
        echo "$script is not executable (mode $(stat -c '%a' "$DOTFILES/make/$script"))" >&2
        return 1
    fi

    if command -v timeout >/dev/null 2>&1; then
        timeout --signal=TERM --kill-after=30 "$EXTRAS_TIMEOUT" "$DOTFILES/make/$script"
    else
        "$DOTFILES/make/$script"
    fi
}

################################################################################
# MAIN
################################################################################

echo "################################################################################"
echo "# dotfiles container test"
echo "#   distro=$DISTRO  phase=$PHASE  staging=$STAGING"
echo "#   $(uname -a)"
echo "################################################################################"

run_step stage_repo step_stage_repo || {
    echo "cannot continue without a staged repo" >&2
    echo
    echo "##### SUMMARY"
    echo "stage_repo|1"
    echo "##### FAILED=1 TOTAL=1"
    exit 1
}

run_step syntax step_syntax
run_step shellcheck step_shellcheck
run_step dispatch step_dispatch

if [ "$PHASE" = "full" ]; then
    if [ "$DISTRO" = "termux" ]; then
        run_step termux_installer step_termux_installer
    else
        run_step install step_install
    fi
fi

run_step init step_init
run_step symlinks step_symlinks

if [ "$PHASE" = "full" ]; then
    run_step appimage_check step_appimage_check
    run_step make_test step_make_test
fi

# The optional tool sets. Deliberately after init/symlinks (some of them look for shell
# config that init.sh links) and before repo_dirty, which is the real test of two of the
# decisions in these scripts: gcloud's installer is run with --path-update=false so it
# cannot append to the symlinked ~/.zshrc, and kustomize's upstream installer is given an
# explicit target because it otherwise defaults to $PWD and drops a binary in the checkout.
if [ "$PHASE" = "extras" ]; then
    run_step aws        step_optional install-aws.sh
    run_step gcp        step_optional install-gcp.sh
    run_step azure      step_optional install-azure.sh
    run_step kubernetes step_optional install-kubernetes.sh
    run_step llm        step_optional install-llm.sh
    run_step tui        step_optional install-tui.sh
fi

run_step repo_dirty step_repo_dirty

################################################################################
# SUMMARY
################################################################################

failed=0
echo
echo "##### SUMMARY"
for i in "${!STEP_NAMES[@]}"; do
    printf '%s|%s\n' "${STEP_NAMES[$i]}" "${STEP_CODES[$i]}"
    [ "${STEP_CODES[$i]}" -ne 0 ] && failed=$((failed + 1))
done
echo "##### FAILED=$failed TOTAL=${#STEP_NAMES[@]}"

[ "$failed" -gt 250 ] && failed=250
exit "$failed"
