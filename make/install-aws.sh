#!/bin/bash
################################################################################
# AWS CLI Installation Script
#
# Description: Install AWS CLI v2 and the Session Manager plugin
# Platforms: Debian/Ubuntu, Arch, Amazon Linux / RHEL / Fedora
# Usage: ./make/install-aws.sh   (or `make aws`)
################################################################################

# No `set -e`: one unavailable tool should not abort the rest, the same convention the
# per-OS installers use. install_summary at the end turns the failure tally into the exit
# code, so this is still usable as a gate.
set -u
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/modules/helpers/logger.sh"
source "$SCRIPT_DIR/modules/helpers/pkg.sh"

log_section "AWS Tools"

PLATFORM="$(detect_platform)"
ARCH_UNAME="$(detect_arch_uname)"

if [[ "$ARCH_UNAME" == "unsupported" ]]; then
    log_error "AWS CLI v2 has no build for $(uname -m)"
    exit 1
fi

# Bail before downloading 60MB. AWS publishes only glibc x86_64/aarch64 bundles for Linux,
# and its installer needs root - neither of which Termux has. The container run reached the
# "needs root" error only after the whole archive had been fetched and unpacked.
if [[ "$PLATFORM" == "termux" ]]; then
    record_unsupported "AWS CLI v2" "no Android build, and its installer requires root"
    log_warn "  On Termux use v1 instead: pkg install python-pip && pip install awscli"
    install_summary
    exit $?
fi

# Status checked: a missing unzip used to surface 16 lines later as
# "install-aws.sh: line 46: unzip: command not found", which points at the wrong thing.
if ! ensure_cmds curl unzip; then
    record_failure "prerequisites (curl, unzip)"
    install_summary
    exit $?
fi

################################################################################
# AWS CLI v2
################################################################################

# Everything happens in a temp dir. This used to download into the current directory and
# clean up with `rm -rf aws/ awscliv2.zip` - run from the repo root, which is where make
# puts you, that deleted the repo's own aws/ config directory.
workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

install_awscli() {
    # https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH_UNAME}.zip" \
        -o "$workdir/awscliv2.zip" || return 1
    unzip -q "$workdir/awscliv2.zip" -d "$workdir" || return 1

    # --update makes this idempotent; without it a second run fails with "found an
    # existing AWS CLI installation".
    as_root "$workdir/aws/install" --update
}

if command_exists aws && aws --version 2>&1 | grep -q 'aws-cli/2'; then
    log_skip "AWS CLI v2 already installed ($(aws --version 2>&1))"
else
    safe_exec "AWS CLI v2" install_awscli
fi

################################################################################
# Session Manager plugin
################################################################################

# Upstream ships a .deb and an .rpm but no generic tarball, so Arch has to come from the
# AUR. Previously this ran `dpkg -i` unconditionally, which meant the script could only
# ever work on Debian and Ubuntu despite claiming three platforms.
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
install_session_manager_plugin() {
    local base="https://s3.amazonaws.com/session-manager-downloads/plugin/latest"

    case "$PLATFORM" in
        debian)
            local slug
            case "$ARCH_UNAME" in
                x86_64)  slug=ubuntu_64bit ;;
                aarch64) slug=ubuntu_arm64 ;;
            esac
            curl -fsSL "$base/$slug/session-manager-plugin.deb" \
                -o "$workdir/session-manager-plugin.deb" || return 1
            as_root dpkg -i "$workdir/session-manager-plugin.deb"
            ;;
        rhel)
            local slug
            case "$ARCH_UNAME" in
                x86_64)  slug=linux_64bit ;;
                aarch64) slug=linux_arm64 ;;
            esac
            curl -fsSL "$base/$slug/session-manager-plugin.rpm" \
                -o "$workdir/session-manager-plugin.rpm" || return 1
            # `dnf install` rather than `rpm -i` so dependencies resolve.
            as_root "$(pkg_manager)" install -y "$workdir/session-manager-plugin.rpm"
            ;;
        arch)
            if command_exists yay; then
                yay -S --noconfirm aws-session-manager-plugin
            else
                log_warn "yay not installed - skipping Session Manager plugin"
                log_warn "  install it with: yay -S aws-session-manager-plugin"
                return 0
            fi
            ;;
        *)
            log_warn "No Session Manager plugin package for platform '$PLATFORM', skipping"
            return 0
            ;;
    esac
}

if command_exists session-manager-plugin; then
    log_skip "Session Manager plugin already installed"
else
    safe_exec "Session Manager plugin" install_session_manager_plugin
fi

################################################################################
# SUMMARY
################################################################################

command_exists aws && log_info "aws: $(aws --version 2>&1)"
command_exists session-manager-plugin \
    && log_info "session-manager-plugin: $(session-manager-plugin --version 2>&1)"

install_summary
