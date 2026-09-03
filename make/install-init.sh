#!/usr/bin/env bash
################################################################################
# Installer dispatch - pick the per-OS installer for this machine.
#
# Invoked by `make install`.
################################################################################

set -u

# Resolve the checkout this script belongs to rather than assuming ~/dotfiles, so a
# clone or worktree somewhere else runs its own installers instead of another copy's.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Installers are run as `bash "$script"`, not executed directly: install-termux.sh,
# install-llm.sh and install-tui.sh have all been committed without the execute bit at
# one time or another, and a stale mode bit should not be able to break dispatch.
run_installer() {
    local script="$SCRIPT_DIR/$1"
    if [ ! -r "$script" ]; then
        echo "error: installer not found: $script" >&2
        return 1
    fi
    bash "$script"
}

platform="$(uname)"

# Termux reports uname -s as Linux, so it has to be checked before anything that reads
# /etc/os-release - a file Termux does not have.
if [ "$(uname -o 2>/dev/null)" = "Android" ] || case "${PREFIX:-}" in */com.termux/*) true ;; *) false ;; esac; then
    echo "Termux (Android) detected." >&2
    echo "" >&2
    echo "This dotfiles repo does not support Termux yet. make/install-termux.sh exists" >&2
    echo "but is not wired up here on purpose: it clones over your checkout instead of" >&2
    echo "using it, never calls make/init.sh, and assumes /bin/bash and /tmp, neither of" >&2
    echo "which exists under the Termux prefix. See make/test/README.md." >&2
    echo "" >&2
    echo "For now: pkg install the tools you want, then run 'bash make/init.sh' to link" >&2
    echo "the configs - init.sh itself works correctly on Termux." >&2
    exit 1
fi

if [ "$platform" = "Darwin" ]; then
    echo "MacOS"
    run_installer "mac/install-mac.sh"
    exit $?
fi

# Every branch below needs /etc/os-release. Reading it with `cat` in each condition meant
# that on a system without it (Termux, some minimal containers) the script printed three
# "No such file or directory" errors, fell off the end of the if/elif chain, and exited 0
# - reporting success while installing nothing at all.
if [ ! -r /etc/os-release ]; then
    echo "error: cannot identify this system: /etc/os-release is missing or unreadable." >&2
    echo "       Supported: macOS, Ubuntu/Linux Mint, Amazon Linux, Arch Linux." >&2
    exit 1
fi

# shellcheck source=/dev/null
. /etc/os-release

case "${ID:-}" in
    ubuntu | linuxmint)
        echo "ubuntu/linuxmint"
        run_installer "install-ubuntu.sh"
        ;;
    amzn)
        echo "amzn"
        run_installer "install-amazon-linux.sh"
        ;;
    arch)
        echo "arch"
        run_installer "install-archlinux.sh"
        ;;
    *)
        # Previously there was no else at all, so `make install` on Debian, Fedora,
        # Manjaro or anything else exited 0 having done nothing.
        echo "error: no installer for ID=${ID:-unknown} (${PRETTY_NAME:-unknown})." >&2
        echo "       Supported: macOS, Ubuntu/Linux Mint, Amazon Linux, Arch Linux." >&2
        exit 1
        ;;
esac

status=$?
if [ "$status" -eq 0 ]; then
    echo "Done"
else
    echo "Installer finished with errors (exit $status). See the log above." >&2
fi
exit "$status"
