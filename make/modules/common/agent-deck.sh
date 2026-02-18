#!/bin/bash

if [[ -n "${_AGENT_DECK_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _AGENT_DECK_MODULE_LOADED=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$SCRIPT_DIR/../helpers/logger.sh"
fi

install_agent_deck() {
    log_section "Installing Agent Deck"
    
    if command_exists agent-deck; then
        log_skip "Agent Deck already installed"
        return 0
    fi
    
    log_info "Installing Agent Deck via official script..."
    
    if curl -fsSL https://raw.githubusercontent.com/asheshgoplani/agent-deck/main/install.sh | bash -s -- --non-interactive --skip-tmux-config; then
        log_success "Agent Deck installed"
        return 0
    else
        log_error "Failed to install Agent Deck"
        return 1
    fi
}

verify_agent_deck() {
    log_section "Verifying Agent Deck Installation"
    
    if command_exists agent-deck; then
        log_test "PASS" "Agent Deck command available: $(agent-deck version 2>&1 | head -n 1)"
        return 0
    else
        log_test "FAIL" "Agent Deck command not found"
        return 1
    fi
}
