#!/bin/bash
################################################################################
# FZF Module - Install fuzzy finder
#
# Usage: source this file and call install_fzf
#   source "$(dirname "$0")/modules/common/fzf.sh"
#   install_fzf
################################################################################

# Prevent multiple sourcing
if [[ -n "${_FZF_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _FZF_MODULE_LOADED=1

# Source logger if not already loaded
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$SCRIPT_DIR/../helpers/logger.sh"
fi

################################################################################
# CONFIGURATION
################################################################################

readonly FZF_DIR="$HOME/.fzf"

################################################################################
# FUNCTIONS
################################################################################

# Install FZF
install_fzf() {
    log_section "Installing FZF (Fuzzy Finder)"
    
    if dir_exists "$FZF_DIR"; then
        log_skip "FZF already installed"
        return 0
    fi
    
    log_info "Installing FZF from source..."
    
    if ! git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"; then
        log_error "Failed to clone FZF repository"
        return 1
    fi
    
    if yes | "$FZF_DIR/install"; then
        log_success "FZF installed"
        return 0
    else
        log_error "FZF installation script failed"
        return 1
    fi
}

# Verify FZF installation
verify_fzf() {
    local all_pass=true
    
    log_section "Verifying FZF Installation"
    
    if dir_exists "$FZF_DIR"; then
        log_test "PASS" "FZF directory exists"
    else
        log_test "FAIL" "FZF directory missing"
        all_pass=false
    fi
    
    if command_exists fzf; then
        log_test "PASS" "fzf command available"
    else
        log_test "FAIL" "fzf command not found"
        all_pass=false
    fi
    
    if $all_pass; then
        return 0
    else
        return 1
    fi
}
