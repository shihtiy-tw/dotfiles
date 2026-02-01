#!/bin/bash
################################################################################
# Pyenv Module - Install Python version manager
#
# Usage: source this file and call install_pyenv
#   source "$(dirname "$0")/modules/common/pyenv.sh"
#   install_pyenv
################################################################################

# Prevent multiple sourcing
if [[ -n "${_PYENV_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _PYENV_MODULE_LOADED=1

# Source logger if not already loaded
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$SCRIPT_DIR/../helpers/logger.sh"
fi

################################################################################
# CONFIGURATION
################################################################################

readonly PYENV_DIR="$HOME/.pyenv"

################################################################################
# FUNCTIONS
################################################################################

# Install pyenv
install_pyenv() {
    log_section "Installing Pyenv"
    
    if dir_exists "$PYENV_DIR"; then
        log_skip "Pyenv already installed"
        return 0
    fi
    
    log_info "Installing pyenv..."
    
    if curl https://pyenv.run | bash; then
        log_success "Pyenv installed"
        return 0
    else
        log_error "Failed to install pyenv"
        return 1
    fi
}

# Verify pyenv installation
verify_pyenv() {
    local all_pass=true
    
    log_section "Verifying Pyenv Installation"
    
    if dir_exists "$PYENV_DIR"; then
        log_test "PASS" "Pyenv directory exists"
    else
        log_test "FAIL" "Pyenv directory missing"
        all_pass=false
    fi
    
    if file_exists "$PYENV_DIR/bin/pyenv"; then
        log_test "PASS" "Pyenv binary exists"
    else
        log_test "FAIL" "Pyenv binary missing"
        all_pass=false
    fi
    
    if $all_pass; then
        return 0
    else
        return 1
    fi
}
