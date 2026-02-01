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
    safe_exec "EPEL release" sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
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
if [ ! -d "$HOME/dotfiles/tig" ]; then
    log_info "Installing tig..."
    git clone git://github.com/jonas/tig.git "$HOME/dotfiles/tig"
    make -C "$HOME/dotfiles/tig" || log_error "tig make failed"
    make -C "$HOME/dotfiles/tig" install || log_error "tig install failed"
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
# GO LANGUAGE
################################################################################

log_section "Installing Go"

if ! command -v go &> /dev/null; then
    log_info "Installing Go..."
    wget -q -O - https://git.io/vQhTU | bash
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
