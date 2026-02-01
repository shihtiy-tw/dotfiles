#!/bin/bash
################################################################################
# Rustup Module - Install Rust toolchain via rustup
#
# Usage: source this file and call install_rustup
#   source "$(dirname "$0")/modules/common/rustup.sh"
#   install_rustup
################################################################################

# Prevent multiple sourcing
if [[ -n "${_RUSTUP_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _RUSTUP_MODULE_LOADED=1

# Source logger if not already loaded
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$SCRIPT_DIR/../helpers/logger.sh"
fi

################################################################################
# FUNCTIONS
################################################################################

# Install Rust via rustup
install_rustup() {
    log_section "Installing Rust Toolchain"
    
    if command_exists rustup; then
        log_skip "Rust already installed (rustup found)"
        log_info "Updating rustup..."
        rustup update || log_warn "rustup update failed"
        return 0
    fi
    
    log_info "Installing Rust toolchain via rustup..."
    
    if curl https://sh.rustup.rs -sSf | sh -s -- -y; then
        log_success "Rust toolchain installed"
        
        # Source cargo env for current session
        if file_exists "$HOME/.cargo/env"; then
            # shellcheck source=/dev/null
            source "$HOME/.cargo/env"
            log_info "Cargo environment loaded"
        fi
        
        return 0
    else
        log_error "Failed to install Rust toolchain"
        return 1
    fi
}

# Install a cargo package
# Usage: install_cargo_package "package-name"
install_cargo_package() {
    local package="$1"
    
    if ! command_exists cargo; then
        log_error "Cargo is not available. Please install Rust first."
        return 1
    fi
    
    log_info "Installing cargo package: $package"
    
    if cargo install --locked "$package"; then
        log_success "Installed: $package"
        return 0
    else
        log_error "Failed to install: $package"
        return 1
    fi
}

# Verify Rust installation
verify_rustup() {
    local all_pass=true
    
    log_section "Verifying Rust Installation"
    
    if command_exists rustup; then
        log_test "PASS" "rustup command available"
    else
        log_test "FAIL" "rustup command not found"
        all_pass=false
    fi
    
    if command_exists rustc; then
        log_test "PASS" "rustc compiler: $(rustc --version)"
    else
        log_test "FAIL" "rustc compiler not found"
        all_pass=false
    fi
    
    if command_exists cargo; then
        log_test "PASS" "cargo package manager: $(cargo --version)"
    else
        log_test "FAIL" "cargo not found"
        all_pass=false
    fi
    
    if $all_pass; then
        return 0
    else
        return 1
    fi
}
