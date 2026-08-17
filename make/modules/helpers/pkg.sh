#!/bin/bash
################################################################################
# Platform / package-manager helpers
#
# Usage: source this file, then call detect_platform, pkg_install, as_root, ...
#   source "$(dirname "$0")/modules/helpers/pkg.sh"
#
# The per-OS installers (install-ubuntu.sh and friends) do not need this: they are
# selected by install-init.sh and already know what they are running on. These helpers
# exist for the optional tool scripts - install-aws.sh, install-gcp.sh,
# install-azure.sh, install-kubernetes.sh, install-llm.sh, install-tui.sh - which are
# invoked directly on whatever machine you happen to be sitting at, and which
# previously hardcoded one distro's package manager and failed everywhere else.
################################################################################

# Prevent multiple sourcing
if [[ -n "${_PKG_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _PKG_MODULE_LOADED=1

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$MODULE_DIR/logger.sh"
fi

################################################################################
# PLATFORM DETECTION
################################################################################

# Echo a coarse platform family: debian | arch | rhel | termux | macos | unknown
#
# Deliberately coarse. The scripts that use this care about which package manager and
# which release-asset naming to use, not whether they are on Mint or Pop!_OS.
detect_platform() {
    # Termux first: it ships no /etc/os-release, which is what made `make install`
    # print three "No such file or directory" lines there and then exit 0.
    if [[ -n "${TERMUX_VERSION:-}" ]] || [[ "${PREFIX:-}" == *com.termux* ]]; then
        echo termux
        return 0
    fi

    if [[ "$(uname -s)" == "Darwin" ]]; then
        echo macos
        return 0
    fi

    if [[ -r /etc/os-release ]]; then
        # Locals with defaults: /etc/os-release is not guaranteed to define ID_LIKE, and
        # referencing an unset one under `set -u` is fatal.
        local ID="" ID_LIKE=""
        # shellcheck source=/dev/null
        . /etc/os-release

        case "$ID" in
            ubuntu | debian | linuxmint | pop | raspbian | elementary | zorin)
                echo debian; return 0 ;;
            arch | manjaro | endeavouros | garuda | artix)
                echo arch; return 0 ;;
            amzn | rhel | centos | fedora | rocky | almalinux | ol)
                echo rhel; return 0 ;;
        esac

        # Fall back to ID_LIKE for derivatives not named above.
        case " $ID_LIKE " in
            *" debian "*)                 echo debian; return 0 ;;
            *" arch "*)                   echo arch;   return 0 ;;
            *" rhel "* | *" fedora "*)    echo rhel;   return 0 ;;
        esac
    fi

    echo unknown
}

# Echo the package manager command: apt | pacman | dnf | yum | pkg | brew | unknown
pkg_manager() {
    case "$(detect_platform)" in
        debian) echo apt ;;
        arch)   echo pacman ;;
        rhel)
            # Amazon Linux 2023 and Fedora have dnf; Amazon Linux 2 only has yum.
            if command_exists dnf; then echo dnf; else echo yum; fi
            ;;
        termux) echo pkg ;;
        macos)  echo brew ;;
        *)      echo unknown ;;
    esac
}

# Echo the architecture in Go/release-asset style: amd64 | arm64 | arm | unsupported
detect_arch() {
    case "$(uname -m)" in
        x86_64 | amd64)  echo amd64 ;;
        aarch64 | arm64) echo arm64 ;;
        armv7l | armv6l) echo arm ;;
        *)               echo unsupported ;;
    esac
}

# Echo the architecture in uname style: x86_64 | aarch64 | unsupported
detect_arch_uname() {
    case "$(uname -m)" in
        x86_64 | amd64)  echo x86_64 ;;
        aarch64 | arm64) echo aarch64 ;;
        *)               echo unsupported ;;
    esac
}

################################################################################
# PRIVILEGE
################################################################################

# Run a command as root, however that is possible here.
#
# Containers, CI and some cloud images run as root with no sudo installed at all, while a
# normal workstation is the reverse. Both have to work.
#
# apt gets DEBIAN_FRONTEND re-injected through `env`, because sudo's default env_reset
# strips it: a container run showed debconf still reporting "unable to initialize
# frontend: Dialog" despite the variable being exported. `sudo -E` and `sudo VAR=val cmd`
# both need the SETENV sudoers tag, which a stock `%sudo ALL=(ALL:ALL) ALL` does not
# grant; running /usr/bin/env as root is subject to no such policy.
as_root() {
    local wants_env=0

    case "${1:-}" in
        apt | apt-get | aptitude | dpkg | dpkg-reconfigure | debconf-set-selections)
            wants_env=1
            ;;
    esac

    # Each branch is spelled out rather than building an array prefix, because expanding
    # an empty array as "${arr[@]}" is an error under `set -u` in bash 3.2 - which is
    # still what macOS ships.
    if [[ "$(id -u)" -eq 0 ]]; then
        if [[ "$wants_env" -eq 1 ]]; then
            env DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true "$@"
        else
            "$@"
        fi
    elif command_exists sudo; then
        if [[ "$wants_env" -eq 1 ]]; then
            sudo env DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true "$@"
        else
            sudo "$@"
        fi
    else
        log_error "This step needs root and neither root nor sudo is available: $*"
        return 1
    fi
}

# True when we can obtain root at all.
can_root() {
    [[ "$(id -u)" -eq 0 ]] || command_exists sudo
}

################################################################################
# PACKAGES
################################################################################

# Refresh the package index. Best-effort: a stale index is not worth aborting over.
pkg_refresh() {
    _PKG_REFRESHED=1
    case "$(pkg_manager)" in
        apt)    as_root apt-get update -qq ;;
        pacman) as_root pacman -Sy --noconfirm ;;
        dnf)    as_root dnf -q makecache ;;
        yum)    as_root yum -q makecache ;;
        pkg)    pkg update -y ;;
        brew)   brew update ;;
        *)      log_warn "Unknown package manager, skipping index refresh"; return 0 ;;
    esac
}

# Install one or more packages non-interactively.
#
# Every one of these takes the flag that stops it asking questions. The audit found seven
# installs across these scripts that omitted it, each of which hangs an unattended run
# forever rather than failing.
pkg_install() {
    [[ $# -gt 0 ]] || return 0

    # Refresh once per script run before the first install. Without this, an apt whose
    # /var/lib/apt/lists is empty reports "Unable to locate package unzip" for packages
    # that plainly exist - which is what happened to aws, azure and tui in the container
    # run, because the extras phase never goes through install-ubuntu.sh's apt-get update.
    # Debian derivatives ship an empty index in exactly the same way after a
    # `rm -rf /var/lib/apt/lists/*`, so this is not only a test artifact.
    if [[ "${_PKG_REFRESHED:-0}" -ne 1 ]]; then
        case "$(pkg_manager)" in
            apt | dnf | yum | pkg) pkg_refresh || log_warn "Index refresh failed, trying anyway" ;;
            *) _PKG_REFRESHED=1 ;;
        esac
    fi

    case "$(pkg_manager)" in
        apt)    as_root apt-get install -y "$@" ;;
        pacman) as_root pacman -S --needed --noconfirm "$@" ;;
        dnf)    as_root dnf install -y "$@" ;;
        yum)    as_root yum install -y "$@" ;;
        pkg)    pkg install -y "$@" ;;
        brew)   brew install "$@" ;;
        *)
            log_error "Cannot install $* - unrecognised platform ($(detect_platform))"
            return 1
            ;;
    esac
}

# Make sure the given commands exist, installing them if not.
#
# Takes command names, not package names, and maps the handful that differ. Nearly every
# script here needs curl/tar/unzip and none of them used to check.
ensure_cmds() {
    local -a missing=()
    local cmd pkg

    for cmd in "$@"; do
        command_exists "$cmd" && continue

        case "$cmd:$(pkg_manager)" in
            unzip:*)      pkg=unzip ;;
            curl:*)       pkg=curl ;;
            tar:*)        pkg=tar ;;
            gpg:apt)      pkg=gnupg ;;
            gpg:*)        pkg=gnupg2 ;;
            # Termux splits the openssl CLI out of the library package.
            openssl:pkg)  pkg=openssl-tool ;;
            *)            pkg="$cmd" ;;
        esac
        missing+=("$pkg")
    done

    [[ ${#missing[@]} -eq 0 ]] && return 0

    log_info "Installing prerequisites: ${missing[*]}"
    pkg_install "${missing[@]}"
}

################################################################################
# BINARY INSTALLATION
################################################################################

# Echo the directory unprivileged binaries go in, creating it.
user_bin_dir() {
    local dir="$HOME/.local/bin"
    mkdir -p "$dir"
    echo "$dir"
}

# Install an executable, preferring /usr/local/bin and falling back to ~/.local/bin.
#
# Usage: install_binary <src-path> [dest-name]
install_binary() {
    local src="$1"
    local name="${2:-$(basename "$src")}"

    # Termux has no /usr/local/bin on PATH - and on a rooted device with tsu, can_root is
    # true, so without this a binary would be installed somewhere the shell never looks.
    # $PREFIX/bin is the platform's own equivalent and needs no privilege.
    if [[ "$(detect_platform)" == "termux" && -n "${PREFIX:-}" && -d "$PREFIX/bin" ]]; then
        install -m 0755 "$src" "$PREFIX/bin/$name"
        return
    fi

    if can_root; then
        as_root install -m 0755 "$src" "/usr/local/bin/$name"
    else
        local dir
        dir="$(user_bin_dir)"
        install -m 0755 "$src" "$dir/$name"
        log_warn "No root available - installed $name to $dir (ensure it is on PATH)"
    fi
}
