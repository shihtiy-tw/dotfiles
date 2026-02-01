#!/bin/bash
################################################################################
# Tmux TPM Module - Install Tmux Plugin Manager
#
# Usage: source this file and call install_tmux_tpm
#   source "$(dirname "$0")/modules/common/tmux-tpm.sh"
#   install_tmux_tpm
################################################################################

# Prevent multiple sourcing
if [[ -n "${_TMUX_TPM_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _TMUX_TPM_MODULE_LOADED=1

# Source logger if not already loaded
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$SCRIPT_DIR/../helpers/logger.sh"
fi

################################################################################
# CONFIGURATION
################################################################################

readonly TPM_DIR="$HOME/.tmux/plugins/tpm"
readonly TPM_REPO="https://github.com/tmux-plugins/tpm"

################################################################################
# FUNCTIONS
################################################################################

# Install Tmux Plugin Manager
install_tmux_tpm() {
    log_section "Installing Tmux Plugin Manager"
    
    if dir_exists "$TPM_DIR"; then
        log_skip "Tmux TPM already installed"
        return 0
    fi
    
    log_info "Installing Tmux Plugin Manager..."
    
    # Create plugins directory
    mkdir -p "$(dirname "$TPM_DIR")"
    
    if git clone "$TPM_REPO" "$TPM_DIR"; then
        log_success "Tmux TPM installed"
        log_info "Note: Press prefix + I in tmux to install plugins"
        return 0
    else
        log_error "Failed to install Tmux TPM"
        return 1
    fi
}

# Verify TPM installation
verify_tmux_tpm() {
    local all_pass=true
    
    log_section "Verifying Tmux TPM Installation"
    
    if dir_exists "$TPM_DIR"; then
        log_test "PASS" "TPM directory exists"
    else
        log_test "FAIL" "TPM directory missing"
        all_pass=false
    fi
    
    if file_exists "$TPM_DIR/tpm"; then
        log_test "PASS" "TPM executable exists"
    else
        log_test "FAIL" "TPM executable missing"
        all_pass=false
    fi
    
    if $all_pass; then
        return 0
    else
        return 1
    fi
}
