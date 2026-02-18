#!/bin/bash
################################################################################
# macOS Development Environment Setup Script
#
# Description: Automated installation of development tools for macOS
# Author: shihtiy-tw
# Platforms: macOS (Apple Silicon and Intel)
# Last Updated: 2026-02-01
################################################################################

set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

################################################################################
# SETUP - Source Shared Modules
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source shared modules (from parent directory)
source "$SCRIPT_DIR/../modules/helpers/logger.sh"
source "$SCRIPT_DIR/../modules/common/oh-my-zsh.sh"
source "$SCRIPT_DIR/../modules/common/nvm.sh"
source "$SCRIPT_DIR/../modules/common/rustup.sh"
source "$SCRIPT_DIR/../modules/common/autojump.sh"
source "$SCRIPT_DIR/../modules/common/tmux-tpm.sh"
source "$SCRIPT_DIR/../modules/common/gitflow.sh"
source "$SCRIPT_DIR/../modules/common/pyenv.sh"
source "$SCRIPT_DIR/../modules/common/fzf.sh"
source "$SCRIPT_DIR/../modules/common/bun.sh"
source "$SCRIPT_DIR/../modules/common/agent-deck.sh"
source "$SCRIPT_DIR/../modules/common/vibe-kanban.sh"

################################################################################
# HOMEBREW
################################################################################

log_section "Installing Homebrew"

if ! command -v brew &> /dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session
    if [[ $(uname -m) == 'arm64' ]]; then
        echo >> "$HOME/.zprofile"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo >> "$HOME/.bash_profile"
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.bash_profile"
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    log_success "Homebrew installed"
else
    log_skip "Homebrew already installed"
fi

################################################################################
# BREWFILE
################################################################################

log_section "Installing Brew Packages"

cd "$SCRIPT_DIR" || exit

if [[ $(uname -m) == 'arm64' ]]; then
    log_info "Running on Apple Silicon (ARM)"
    if [ -f Brewfile.arm ]; then
        brew bundle --file Brewfile.arm
    else
        log_warn "Brewfile.arm not found"
    fi
else
    log_info "Running on Intel (x86)"
    if [ -f Brewfile.x86 ]; then
        brew bundle --file Brewfile.x86
    else
        log_warn "Brewfile.x86 not found"
    fi
fi

################################################################################
# SHELL CONFIGURATION
################################################################################

log_section "Shell Configuration"

# Oh-My-Zsh - using shared module
install_oh_my_zsh

################################################################################
# DEVELOPMENT TOOLS
################################################################################

log_section "Installing Development Tools"

# Tmux TPM - using shared module
install_tmux_tpm

# Kitty terminal
log_info "Installing Kitty..."
if ! command -v kitty &> /dev/null; then
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin || log_error "Kitty installation failed"
    log_success "Kitty installed"
else
    log_skip "Kitty already installed"
fi

# Rust - using shared module
install_rustup

# NVM and Node.js - using shared module
install_nvm_with_node

# Autojump - using shared module
install_autojump

# Pyenv - using shared module
install_pyenv

# FZF - using shared module
install_fzf

# Gitflow - using shared module
install_gitflow

################################################################################
# AI TOOLS
################################################################################

log_section "Installing AI Tools"

# Agent Deck: AI workspace manager - Using shared module
install_agent_deck

# Vibe Kanban: AI-native kanban - Using shared module
install_vibe_kanban

################################################################################
# RUBY
################################################################################

log_section "Installing Ruby Tools"

if brew list rbenv &> /dev/null; then
    log_skip "rbenv already installed via Homebrew"
else
    safe_exec "rbenv" brew install rbenv ruby-build
fi

# Add rbenv init to bash_profile if not present
if ! grep -q "rbenv init" "$HOME/.bash_profile" 2>/dev/null; then
    echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> "$HOME/.bash_profile"
    log_success "rbenv init added to .bash_profile"
fi

################################################################################
# INPUT METHOD
################################################################################

log_section "Installing Input Method Tools"

# im-select for neovim
log_info "Installing macism for im-select.nvim..."
if ! brew list macism &> /dev/null; then
    brew tap laishulu/homebrew
    brew install macism
    log_success "macism installed"
else
    log_skip "macism already installed"
fi

# Rime input method
log_info "Installing Rime..."
curl -fsSL https://git.io/rime-install | bash || log_warn "Rime installation may have issues"

################################################################################
# CLEANUP
################################################################################

log_section "Cleanup"

brew cleanup

################################################################################
# COMPLETION
################################################################################

log_section "Installation Complete"

cd "$HOME" || true

echo ""
log_success "macOS setup complete!"
echo ""
log_info "Next steps:"
echo "  1. Run 'make init' to create dotfile symlinks"
echo "  2. Set default shell: chsh -s \$(which zsh)"
echo "  3. Open a new terminal session"
echo ""
