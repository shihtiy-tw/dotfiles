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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$SCRIPT_DIR/../helpers/logger.sh"
fi

################################################################################
# CONFIGURATION
################################################################################

readonly GITFLOW_INSTALLER_URL="https://raw.githubusercontent.com/CJ-Systems/gitflow-cjs/develop/contrib/gitflow-installer.sh"

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
    
    local tmp_installer="/tmp/gitflow-installer-$$.sh"
    
    if ! wget -q "$GITFLOW_INSTALLER_URL" -O "$tmp_installer"; then
        log_error "Failed to download git-flow installer"
        return 1
    fi
    
    if sudo bash "$tmp_installer" install stable; then
        log_success "Git-flow CJS installed"
        rm -f "$tmp_installer"
        return 0
    else
        log_error "Failed to install git-flow"
        rm -f "$tmp_installer"
        return 1
    fi
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
