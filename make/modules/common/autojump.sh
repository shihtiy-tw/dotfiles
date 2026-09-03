#!/bin/bash
################################################################################
# Autojump Module - Install autojump directory navigator
#
# Usage: source this file and call install_autojump
#   source "$(dirname "$0")/modules/common/autojump.sh"
#   install_autojump
################################################################################

# Prevent multiple sourcing
if [[ -n "${_AUTOJUMP_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _AUTOJUMP_MODULE_LOADED=1

# Source logger if not already loaded
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$MODULE_DIR/../helpers/logger.sh"
fi

################################################################################
# CONFIGURATION
################################################################################

readonly AUTOJUMP_DIR="$HOME/.autojump"

################################################################################
# FUNCTIONS
################################################################################

# Install autojump from source
install_autojump() {
    log_section "Installing Autojump"

    if dir_exists "$AUTOJUMP_DIR/bin" && file_exists "$AUTOJUMP_DIR/bin/autojump"; then
        log_skip "Autojump already installed"
        return 0
    fi

    log_info "Installing autojump from source..."

    local tmp_dir="${TMPDIR:-/tmp}/autojump-install-$$"

    if ! git clone --depth 1 https://github.com/wting/autojump.git "$tmp_dir"; then
        log_error "Failed to clone autojump repository"
        return 1
    fi

    # autojump's install.py picks its target shell from $SHELL and hard-fails with
    # "Unsupported shell: None" when it is unset - which is the norm under docker,
    # cloud-init and packer. Fall back to bash rather than leaving it undefined.
    if (cd "$tmp_dir" && SHELL="${SHELL:-/bin/bash}" python3 install.py); then
        log_success "Autojump installed"
        rm -rf "$tmp_dir"
        return 0
    else
        log_error "Failed to install autojump"
        rm -rf "$tmp_dir"
        return 1
    fi
}

# Load autojump into current session.
#
# autojump's own autojump.bash reads $XDG_DATA_HOME without a default, so sourcing it from
# an installer running under `set -u` was a fatal shell error - it killed install-ubuntu.sh
# at line 331 of 480, after two thirds of the packages but before install_summary, so the
# run died with one cryptic line and no ledger. Everything below that point (silversearcher,
# docker, imagemagick, mainline, gcc-14, tig, gh, terraform, packer, agent-deck,
# vibe-kanban) had never been installed on a fresh machine.
#
# `load_autojump || true` at the call site cannot catch this: an unbound variable aborts the
# shell outright rather than returning non-zero. So relax nounset around the source, and
# give XDG_DATA_HOME the value the spec says it defaults to.
load_autojump() {
    local autojump_sh="$AUTOJUMP_DIR/etc/profile.d/autojump.sh"

    file_exists "$autojump_sh" || return 0

    local restore_nounset=0
    if [[ -o nounset ]]; then
        restore_nounset=1
        set +u
    fi

    export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
    # shellcheck source=/dev/null
    source "$autojump_sh"

    [[ "$restore_nounset" -eq 1 ]] && set -u
    log_info "Autojump loaded into current session"
    return 0
}

# Verify autojump installation
verify_autojump() {
    local all_pass=true

    log_section "Verifying Autojump Installation"

    if dir_exists "$AUTOJUMP_DIR"; then
        log_test "PASS" "Autojump directory exists"
    else
        log_test "FAIL" "Autojump directory missing"
        all_pass=false
    fi

    if file_exists "$AUTOJUMP_DIR/bin/autojump"; then
        log_test "PASS" "Autojump binary exists"
    else
        log_test "FAIL" "Autojump binary missing"
        all_pass=false
    fi

    if file_exists "$AUTOJUMP_DIR/etc/profile.d/autojump.sh"; then
        log_test "PASS" "Autojump shell script exists"
    else
        log_test "FAIL" "Autojump shell script missing"
        all_pass=false
    fi

    if $all_pass; then
        return 0
    else
        return 1
    fi
}
