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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$SCRIPT_DIR/../helpers/logger.sh"
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
    
    local tmp_dir="/tmp/autojump-install-$$"
    
    if ! git clone https://github.com/wting/autojump.git "$tmp_dir"; then
        log_error "Failed to clone autojump repository"
        return 1
    fi
    
    if (cd "$tmp_dir" && python3 install.py); then
        log_success "Autojump installed"
        rm -rf "$tmp_dir"
        return 0
    else
        log_error "Failed to install autojump"
        rm -rf "$tmp_dir"
        return 1
    fi
}

# Load autojump into current session
load_autojump() {
    local autojump_sh="$AUTOJUMP_DIR/etc/profile.d/autojump.sh"
    
    if file_exists "$autojump_sh"; then
        # shellcheck source=/dev/null
        source "$autojump_sh"
        log_info "Autojump loaded into current session"
    fi
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
