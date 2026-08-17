#!/bin/bash
################################################################################
# NVM Module - Install Node Version Manager and Node.js
#
# Usage: source this file and call install_nvm
#   source "$(dirname "$0")/modules/common/nvm.sh"
#   install_nvm
#   install_node "20"  # Install specific Node version
################################################################################

# Prevent multiple sourcing
if [[ -n "${_NVM_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _NVM_MODULE_LOADED=1

# Source logger if not already loaded
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$MODULE_DIR/../helpers/logger.sh"
fi

################################################################################
# CONFIGURATION
################################################################################

readonly NVM_VERSION="v0.40.0"
readonly NVM_DIR_PATH="${NVM_DIR:-$HOME/.nvm}"
readonly DEFAULT_NODE_VERSION="20"

################################################################################
# FUNCTIONS
################################################################################

# Install NVM (Node Version Manager)
install_nvm() {
    log_section "Installing NVM (Node Version Manager)"

    if dir_exists "$NVM_DIR_PATH" && file_exists "$NVM_DIR_PATH/nvm.sh"; then
        log_skip "NVM already installed"
        _load_nvm
        return 0
    fi

    log_info "Installing NVM $NVM_VERSION..."

    if curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash; then
        log_success "NVM installed"
        _load_nvm
        return 0
    else
        log_error "Failed to install NVM"
        return 1
    fi
}

# Load NVM into current shell session
_load_nvm() {
    export NVM_DIR="$NVM_DIR_PATH"

    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
        # shellcheck source=/dev/null
        \. "$NVM_DIR/nvm.sh"
        log_info "NVM loaded into current session"
    fi

    if [[ -s "$NVM_DIR/bash_completion" ]]; then
        # shellcheck source=/dev/null
        \. "$NVM_DIR/bash_completion"
    fi
}

# Install a specific Node.js version
# Usage: install_node "20" or install_node "18.17.0"
install_node() {
    local version="${1:-$DEFAULT_NODE_VERSION}"

    log_info "Installing Node.js version $version..."

    # Ensure NVM is loaded
    _load_nvm

    if ! command_exists nvm; then
        log_error "NVM is not available. Please install NVM first."
        return 1
    fi

    if nvm install "$version"; then
        log_success "Node.js $version installed"
        nvm use "$version"
        log_info "Node version: $(node -v)"
        log_info "NPM version: $(npm -v)"
        return 0
    else
        log_error "Failed to install Node.js $version"
        return 1
    fi
}

# Install NVM and default Node version
install_nvm_with_node() {
    install_nvm
    install_node "$DEFAULT_NODE_VERSION"
}

# Verify NVM installation
verify_nvm() {
    local all_pass=true

    log_section "Verifying NVM Installation"

    # Check NVM directory
    if dir_exists "$NVM_DIR_PATH"; then
        log_test "PASS" "NVM directory exists: $NVM_DIR_PATH"
    else
        log_test "FAIL" "NVM directory missing"
        all_pass=false
    fi

    # Check nvm.sh script
    if file_exists "$NVM_DIR_PATH/nvm.sh"; then
        log_test "PASS" "NVM script exists"
    else
        log_test "FAIL" "NVM script missing"
        all_pass=false
    fi

    # Load and check NVM command
    _load_nvm
    if command_exists nvm; then
        log_test "PASS" "NVM command available"
    else
        log_test "FAIL" "NVM command not available"
        all_pass=false
    fi

    # Check Node installation
    if command_exists node; then
        log_test "PASS" "Node.js installed: $(node -v)"
    else
        log_test "FAIL" "Node.js not installed"
        all_pass=false
    fi

    if $all_pass; then
        return 0
    else
        return 1
    fi
}
