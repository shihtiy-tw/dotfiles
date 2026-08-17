#!/bin/bash
################################################################################
# Amazon Linux Development Environment Setup Script
#
# Description: Automated installation of development tools for Amazon Linux
# Author: shihtiy-tw
# Platforms: Amazon Linux 2
# Last Updated: 2026-02-01
################################################################################

set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

################################################################################
# SETUP - Source Shared Modules
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source shared modules
source "$SCRIPT_DIR/modules/helpers/logger.sh"
source "$SCRIPT_DIR/modules/common/oh-my-zsh.sh"
source "$SCRIPT_DIR/modules/common/nvm.sh"
source "$SCRIPT_DIR/modules/common/autojump.sh"
source "$SCRIPT_DIR/modules/common/tmux-tpm.sh"
source "$SCRIPT_DIR/modules/common/fzf.sh"
source "$SCRIPT_DIR/modules/common/pyenv.sh"
source "$SCRIPT_DIR/modules/common/bun.sh"
source "$SCRIPT_DIR/modules/common/agent-deck.sh"
source "$SCRIPT_DIR/modules/common/vibe-kanban.sh"

################################################################################
# SYSTEM UPDATE
################################################################################

log_section "System Update"

safe_exec "System update" sudo yum update -y

log_section "Installing Build Tools"

safe_exec "Development tools" sudo yum -y groupinstall development
safe_exec "Build dependencies" sudo yum install -y gcc zlib-devel bzip2 bzip2-devel \
    readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
safe_exec "FUSE" sudo yum install -y fuse

################################################################################
# PYTHON
################################################################################

log_section "Installing Python"

if [ "$HOME" = "/root" ]; then
    safe_exec "Python3 packages" sudo yum -y install python3*
    # Derive the EPEL major version instead of pinning el7. This was hardcoded to
    # epel-release-latest-7, which is wrong on Amazon Linux 2023 (el9).
    epel_major="$(rpm -E %{rhel} 2>/dev/null || true)"
    if [[ "$epel_major" =~ ^[0-9]+$ ]]; then
        safe_exec "EPEL release" sudo yum install -y \
            "https://dl.fedoraproject.org/pub/epel/epel-release-latest-${epel_major}.noarch.rpm"
    else
        log_warn "Could not determine EPEL major version; skipping EPEL"
    fi
fi

################################################################################
# SHELL CONFIGURATION
################################################################################

log_section "Shell Configuration"

# zsh
safe_exec "Zsh" sudo yum install zsh -y

# Oh-My-Zsh: Using shared module
install_oh_my_zsh

################################################################################
# DEVELOPMENT TOOLS
################################################################################

log_section "Installing Development Tools"

# tig
safe_exec "ncurses" sudo yum install ncurses-devel ncurses -y
if ! command_exists tig; then
    log_info "Installing tig..."
    # Was `git clone git://...` - GitHub disabled the unauthenticated git://
    # protocol in 2022, so this could only ever fail. Also moved out of
    # $HOME/dotfiles: cloning and building inside the dotfiles repo left an
    # untracked nested checkout behind on every run.
    tig_src="$HOME/.local/src/tig"
    if [ ! -d "$tig_src" ]; then
        safe_exec "tig clone" git clone --depth 1 https://github.com/jonas/tig.git "$tig_src"
    fi
    # prefix into ~/.local so `make install` does not need root.
    make -C "$tig_src" prefix="$HOME/.local" || log_error "tig make failed"
    make -C "$tig_src" prefix="$HOME/.local" install || log_error "tig install failed"
    log_success "Tig installed"
else
    log_skip "Tig already installed"
fi

# tmux
safe_exec "Tmux" sudo yum install tmux -y
install_tmux_tpm

# vim
safe_exec "Vim" sudo yum install vim -y

# diff-so-fancy
log_info "Installing diff-so-fancy..."
if [ ! -f /usr/local/bin/diff-so-fancy ]; then
    wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O /tmp/diff-so-fancy
    chmod a+x /tmp/diff-so-fancy
    sudo mv /tmp/diff-so-fancy /usr/local/bin/diff-so-fancy
    log_success "diff-so-fancy installed"
else
    log_skip "diff-so-fancy already installed"
fi

################################################################################
# NODE.JS
################################################################################

log_section "Installing Node.js"

# NVM and Node.js using shared module
install_nvm_with_node

# Bun - Using shared module
install_bun

# Language servers
if command -v npm &> /dev/null; then
    safe_exec "bash-language-server" sudo npm i -g bash-language-server
    safe_exec "markdownlint-cli" sudo npm install -g markdownlint-cli
fi

################################################################################
# ADDITIONAL TOOLS
################################################################################

log_section "Installing Additional Tools"

safe_exec "iperf3" sudo yum install -y iperf3
safe_exec "jq" sudo yum install -y jq
safe_exec "atop" sudo yum install -y atop

# hping3 (needs EPEL)
if sudo amazon-linux-extras list | grep -q epel; then
    safe_exec "EPEL extras" sudo amazon-linux-extras install epel -y
fi
safe_exec "hping3" sudo yum install -y hping3 || true

################################################################################
# NEOVIM
################################################################################

log_section "Installing Neovim"

if ! command -v nvim &> /dev/null; then
    log_info "Installing Neovim from AppImage..."
    wget -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
    chmod u+x /tmp/nvim.appimage
    sudo rm -f /usr/bin/nvim
    sudo mv /tmp/nvim.appimage /usr/bin/nvim
    log_success "Neovim installed"
else
    log_skip "Neovim already installed"
fi

# Python providers
pip3 install pynvim --user || true
if command -v npm &> /dev/null; then
    sudo npm install -g neovim || true
fi

################################################################################
# FZF & AUTOJUMP
################################################################################

log_section "Installing FZF and Autojump"

install_fzf
install_autojump

################################################################################
# AI TOOLS
################################################################################

log_section "Installing AI Tools"

# Agent Deck: AI workspace manager - Using shared module
install_agent_deck

# Vibe Kanban: AI-native kanban - Using shared module
install_vibe_kanban

################################################################################
# GO LANGUAGE
################################################################################

log_section "Installing Go"

if ! command -v go &> /dev/null; then
    log_info "Installing Go..."
    # Was `wget -q -O - https://git.io/vQhTU | bash`. git.io was shut down by
    # GitHub in 2022, so that piped an HTML error page straight into bash.
    case "$(uname -m)" in
        x86_64)          go_arch=amd64 ;;
        aarch64 | arm64) go_arch=arm64 ;;
        *)               go_arch="" ;;
    esac

    if [ -z "$go_arch" ]; then
        log_error "Unsupported architecture for Go: $(uname -m)"
    else
        go_version="$(curl -fsSL 'https://go.dev/VERSION?m=text' 2>/dev/null | head -1)"
        if [[ "$go_version" =~ ^go[0-9] ]]; then
            go_tarball="$(mktemp -d)/go.tar.gz"
            if curl -fsSL -o "$go_tarball" \
                "https://go.dev/dl/${go_version}.linux-${go_arch}.tar.gz"; then
                # The documented upgrade path: remove the old tree before extracting.
                safe_exec "Remove previous Go" sudo rm -rf /usr/local/go
                safe_exec "Extract Go" sudo tar -C /usr/local -xzf "$go_tarball"
                log_success "Go ${go_version} installed to /usr/local/go"
            else
                log_error "Go download failed"
            fi
            rm -rf "$(dirname "$go_tarball")"
        else
            log_error "Could not determine latest Go version"
        fi
    fi
else
    log_skip "Go already installed"
fi

# Go tools
if command -v go &> /dev/null; then
    safe_exec "efm-langserver" go install github.com/mattn/efm-langserver@latest
fi

################################################################################
# PYTHON SYMLINK
################################################################################

log_info "Creating python symlink..."
if [ ! -f /usr/local/bin/python ] && command -v python3 &> /dev/null; then
    sudo ln -sf "$(which python3)" /usr/local/bin/python
    log_success "Python symlink created"
else
    log_skip "Python symlink already exists"
fi

################################################################################
# SILVER SEARCHER
################################################################################

safe_exec "Silver Searcher" sudo yum install epel-release.noarch the_silver_searcher -y || true

################################################################################
# COMPLETION
################################################################################

log_section "Installation Complete"

cd "$HOME" || true

echo ""
log_success "Amazon Linux setup complete!"
echo ""
log_info "Next steps:"
echo "  1. Run 'make init' to create symlinks"
echo "  2. Log out and back in for group changes"
echo "  3. Run 'chsh -s \$(which zsh)' to set Zsh as default shell"
echo ""
