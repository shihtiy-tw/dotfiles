#!/bin/bash
################################################################################
# Bun Module - Install Bun Javascript Runtime
#
# Usage: source this file and call install_bun
#   source "$(dirname "$0")/modules/common/bun.sh"
#   install_bun
################################################################################

# Prevent multiple sourcing
if [[ -n "${_BUN_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _BUN_MODULE_LOADED=1

# Source logger if not already loaded
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$SCRIPT_DIR/../helpers/logger.sh"
fi

################################################################################
# FUNCTIONS
################################################################################

# Install Bun
install_bun() {
    log_section "Installing Bun"
    
    if command -v bun &> /dev/null; then
        log_skip "Bun already installed: $(bun --version)"
        return 0
    fi
    
    log_info "Installing Bun via curl..."
    
    # Run the installation script
    if curl -fsSL https://bun.sh/install | bash; then
        export BUN_INSTALL="$HOME/.bun"
        export PATH="$BUN_INSTALL/bin:$PATH"
        log_success "Bun installed successfully"
        log_info "Bun version: $(bun --version)"
        return 0
    else
        log_error "Failed to install Bun"
        return 1
    fi
}
