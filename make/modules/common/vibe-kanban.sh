#!/bin/bash

if [[ -n "${_VIBE_KANBAN_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _VIBE_KANBAN_MODULE_LOADED=1

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$MODULE_DIR/../helpers/logger.sh"
fi

install_vibe_kanban() {
    log_section "Installing Vibe Kanban"

    if ! command_exists npm; then
        log_error "npm is required for Vibe Kanban"
        return 1
    fi

    # Install under ~/.local rather than npm's default global prefix. When npm comes from
    # the distro (Arch, Debian) that prefix is /usr, so `npm install -g` dies with EACCES
    # on /usr/lib/node_modules for any non-root user. ~/.local/bin is on PATH via
    # zsh/env.zsh and works the same whether npm came from nvm or from a package.
    log_info "Installing vibe-kanban via npm into ~/.local..."
    if npm install -g --prefix "$HOME/.local" vibe-kanban; then
        log_success "Vibe Kanban installed"
        return 0
    else
        log_error "Failed to install Vibe Kanban"
        return 1
    fi
}

verify_vibe_kanban() {
    log_section "Verifying Vibe Kanban"
    if command_exists vibe-kanban; then
        log_test "PASS" "Vibe Kanban command available"
        return 0
    else
        log_test "FAIL" "Vibe Kanban command not found"
        return 1
    fi
}
