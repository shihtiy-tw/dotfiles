#!/bin/bash
################################################################################
# Gitflow Module - Install git-flow CJS
#
# Usage: source this file and call install_gitflow
#   source "$(dirname "$0")/modules/common/gitflow.sh"
#   install_gitflow
################################################################################

# Prevent multiple sourcing
if [[ -n "${_GITFLOW_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _GITFLOW_MODULE_LOADED=1

# Source logger if not already loaded
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$MODULE_DIR/../helpers/logger.sh"
fi

################################################################################
# CONFIGURATION
################################################################################

# The CJ-Systems/gitflow-cjs fork this used to point at has been gutted upstream: the
# repo still resolves but contrib/ was deleted, so the installer URL is a permanent 404
# on every branch. petervanderdoes/gitflow-avh is the maintained edition that fork came
# from, and it is what the distro `git-flow` packages ship.
readonly GITFLOW_INSTALLER_URL="https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh"

################################################################################
# FUNCTIONS
################################################################################

# Install git-flow CJS
install_gitflow() {
    log_section "Installing Git-flow CJS"

    if command_exists git-flow; then
        log_skip "Git-flow already installed"
        return 0
    fi

    log_info "Installing git-flow CJS..."

    local tmp_installer="${TMPDIR:-/tmp}/gitflow-installer-$$.sh"

    # curl, not wget: Amazon Linux 2023 ships curl-minimal and no wget at all.
    # -f so an HTTP error page is not saved and then executed as a shell script.
    if ! curl -fsSL "$GITFLOW_INSTALLER_URL" -o "$tmp_installer"; then
        log_error "Failed to download git-flow installer from $GITFLOW_INSTALLER_URL"
        return 1
    fi

    # This is the only sudo in make/modules/. Everything else here installs under $HOME,
    # so resolve it rather than assuming: already root needs no sudo, and Termux has no
    # sudo at all - there we install under ~/.local, which the installer honours.
    local rc=0
    if [ "$(id -u)" -eq 0 ]; then
        bash "$tmp_installer" install stable || rc=$?
    elif command_exists sudo; then
        sudo bash "$tmp_installer" install stable || rc=$?
    else
        PREFIX="$HOME/.local" bash "$tmp_installer" install stable || rc=$?
    fi

    rm -f "$tmp_installer"

    if [ "$rc" -eq 0 ]; then
        log_success "Git-flow (AVH) installed"
        return 0
    fi

    log_error "Failed to install git-flow"
    return 1
}

# Verify git-flow installation
verify_gitflow() {
    local all_pass=true

    log_section "Verifying Git-flow Installation"

    if command_exists git-flow; then
        log_test "PASS" "git-flow command available"
    else
        log_test "FAIL" "git-flow command not found"
        all_pass=false
    fi

    if $all_pass; then
        return 0
    else
        return 1
    fi
}
