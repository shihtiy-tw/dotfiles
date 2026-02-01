#!/bin/bash
################################################################################
# Ubuntu/Linux Mint Development Environment Setup Script
#
# Description: Automated installation of development tools and configurations
# Author: shihtiy-tw
# Platforms: Ubuntu, Linux Mint
# Last Updated: 2026-02-01
#
# This script uses shared modules from make/modules/ for common installations.
# To run: ./make/install-ubuntu.sh
################################################################################

# DO NOT exit on error - we want to continue even if some installations fail
# set -e is deliberately NOT used here
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

################################################################################
# SETUP - Source Shared Modules
################################################################################

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source shared logger module (provides log_info, log_error, log_success, etc.)
source "$SCRIPT_DIR/modules/helpers/logger.sh"

# Source common installation modules
source "$SCRIPT_DIR/modules/common/oh-my-zsh.sh"
source "$SCRIPT_DIR/modules/common/nvm.sh"
source "$SCRIPT_DIR/modules/common/rustup.sh"
source "$SCRIPT_DIR/modules/common/autojump.sh"
source "$SCRIPT_DIR/modules/common/tmux-tpm.sh"
source "$SCRIPT_DIR/modules/common/gitflow.sh"
source "$SCRIPT_DIR/modules/common/pyenv.sh"
source "$SCRIPT_DIR/modules/common/fzf.sh"

################################################################################
# CONFIGURATION
################################################################################

# Version
RUBY_GEM_VERSION=3.4.8


################################################################################
# SYSTEM UPDATE
################################################################################

log_section "System Update"
log_info "Updating package lists and upgrading installed packages..."

# Update package lists
safe_exec "apt update" sudo apt update -y

# Upgrade installed packages (non-interactive)
safe_exec "apt upgrade" sudo apt upgrade -y

################################################################################
# BUILD TOOLS & ESSENTIALS
################################################################################

log_section "Installing Build Tools and Essential Packages"

# Install core build tools required for compiling software
# - ninja-build: Fast build system
# - gettext, libtool: Build helpers
# - autoconf, automake, cmake: Build configuration tools
# - g++, build-essential: C/C++ compilers and tools
# - python3-dev, python3-pip: Python development headers
# - pkg-config, unzip: Package configuration and archive tools
log_info "Installing core build tools..."
safe_exec "Core build tools" sudo apt install -y \
    ninja-build \
    gettext libtool libtool-bin \
    autoconf automake cmake g++ \
    build-essential \
    python3-dev python3-pip\
    pkg-config unzip

# Install development libraries required for various tools
# These are dependencies for pyenv, neovim, and other development tools
log_info "Installing development libraries..."
safe_exec "Development libraries" sudo apt install -y \
    make libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

################################################################################
# CLI TOOLS
################################################################################

log_section "Installing CLI Tools"

# Ripgrep: Fast grep alternative
log_info "Installing ripgrep..."
safe_exec "ripgrep" sudo apt-get install -y ripgrep

# Fcitx5: Input method framework for typing in different languages
log_info "Installing fcitx5 input method..."
safe_exec "fcitx5" sudo apt install -y fcitx5

################################################################################
# PROGRAMMING LANGUAGES
################################################################################

log_section "Installing Programming Languages"

# Rust: Systems programming language - Using shared module
install_rustup

# Java: JDK for Java development
log_info "Installing Java JDK..."
safe_exec "Java JDK" sudo apt install -y default-jdk

# Lua: Lightweight scripting language (required for Neovim and other tools)
log_info "Installing Lua and LuaRocks package manager..."
safe_exec "luarocks" sudo apt install -y luarocks

# Go: Google's systems programming language
log_info "Installing Go language..."
safe_exec "golang" sudo apt install -y golang

# Ruby: Dynamic programming language
log_info "Installing Ruby and development headers..."
safe_exec "ruby" sudo apt install -y ruby
safe_exec "ruby-dev" sudo apt-get install -y ruby-dev

# RubyGems: Ruby package manager upgrade
log_info "Upgrading RubyGems to version $RUBY_GEM_VERSION..."
if wget https://rubygems.org/rubygems/rubygems-"$RUBY_GEM_VERSION".tgz; then
    tar xvzf rubygems-"$RUBY_GEM_VERSION".tgz
    (cd rubygems-"$RUBY_GEM_VERSION" && ruby setup.rb) || log_error "RubyGems setup failed"
    cd "$HOME" || true
    rm -f rubygems-"$RUBY_GEM_VERSION".tgz
    log_success "RubyGems upgraded"
else
    log_error "Failed to download RubyGems"
fi

# NVM and Node.js - Using shared module
install_nvm_with_node

# git-sim
sudo apt install pipx -y
sudo apt update
sudo apt install build-essential python3-dev libcairo2-dev libpango1.0-dev ffmpeg -y
pipx install manim
pipx install git-sim

# git
#
#$ curl https://github.com/so-fancy/diff-so-fancy/releases/download/v1.4.4/diff-so-fancy -o /usr/local/bin/diff-so-fancy
LATEST_VERSION=$(curl -s https://api.github.com/repos/so-fancy/diff-so-fancy/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
sudo curl -L -o /usr/local/bin/diff-so-fancy "https://github.com/so-fancy/diff-so-fancy/releases/download/v${LATEST_VERSION}/diff-so-fancy"
sudo chmod +x /usr/local/bin/diff-so-fancy

sudo apt install git-extras

sudo apt install git-lfs

# See ~/dotfiles/git/commit-conventions.txt
git config --global commit.template ~/dotfiles/git/commit-conventions.txt
git config --global core.editor=nvim +18 -c 'startinsert'

# precommit
sudo apt install pre-commit -y

# gitflow-cjs - Using shared module
install_gitflow

# tree
sudo apt install tree

# zsh
sudo apt install zsh powerline fonts-powerline -y

sudo apt install shellcheck -y


# oh-my-zsh: Framework and plugins - Using shared module
# This replaces ~30 lines of manual installation with a single function call
install_oh_my_zsh

# bash-it
#if [ ! -d ${HOME}/.bash_it ]; then \
  #git clone --depth=1 https://github.com/Bash-it/bash-it.git ${HOME}/.bash_it; \
#fi

#${HOME}/bash_it/install.sh --slient
#mkdir -p ${HOME}/.bash_it/custom/themes

################################################################################
# TERMINAL & EDITORS
################################################################################

log_section "Installing Terminal and Editor Tools"

# Tmux: Terminal multiplexer for managing multiple terminal sessions
log_info "Installing tmux..."
safe_exec "tmux" sudo apt install -y tmux

# Tmux Plugin Manager (TPM) - Using shared module
install_tmux_tpm

# vim
# sudo apt-get install vim -y

# Fuse2: Required for running AppImage applications
log_info "Installing libfuse2 for AppImage support..."
safe_exec "libfuse2" sudo apt install -y libfuse2

# Neovim: Modern Vim-based text editor
log_info "Installing Neovim (latest via AppImage)..."
if ! command -v nvim &> /dev/null; then
    if curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage; then
        chmod u+x nvim.appimage
        safe_exec "neovim install" sudo mv nvim.appimage /usr/local/bin/nvim
    else
        log_error "Failed to download Neovim AppImage"
    fi
else

    log_skip "Neovim already installed"
fi

# FZF: Fuzzy finder - Using shared module
install_fzf

# ack
#mkdir -p ${HOME}/.local/share/bin
#curl https://beyondgrep.com/ack-v3.1.2 > ${HOME}/.local/share/bin/ack && chmod 0755 ${HOME}/.local/share/bin/ack

# Autojump: Smart directory navigation - Using shared module
install_autojump

# Yazi: Modern terminal file manager written in Rust
log_info "Installing yazi file manager..."
if ! command -v yazi &> /dev/null; then
    rustup update || log_error "rustup update failed"
    safe_exec "yazi" cargo install --locked yazi-fm yazi-cli
else
    log_skip "Yazi already installed"
fi

# Python3 symlink: Create /usr/local/bin/python pointing to python3
log_info "Creating python3 symlink..."
if [ ! -f /usr/local/bin/python ]; then
    safe_exec "python symlink" sudo ln -s "$(which python3)" /usr/local/bin/python
else
    log_skip "Python symlink already exists"
fi

# Pyenv: Python version manager - Using shared module
install_pyenv

# Source autojump if available
load_autojump || true

# Silver Searcher (Ag): Fast code search tool
log_info "Installing Silver Searcher (ag)..."
safe_exec "Silver Searcher" sudo apt install -y silversearcher-ag

################################################################################
# DOCKER
################################################################################

log_section "Installing Docker"

log_info "Removing old Docker packages..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
    sudo apt-get remove -y "$pkg" 2>/dev/null || true
done

# Add Docker's official GPG key
log_info "Setting up Docker GPG key and repository..."
safe_exec "apt update for Docker" sudo apt-get update
safe_exec "Docker prerequisites" sudo apt-get install -y ca-certificates curl
safe_exec "Docker keyrings dir" sudo install -m 0755 -d /etc/apt/keyrings
safe_exec "Docker GPG key" sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
safe_exec "Docker GPG permissions" sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository to Apt sources
log_info "Adding Docker repository to apt sources..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
safe_exec "apt update after Docker repo" sudo apt-get update

# Install Docker packages
log_info "Installing Docker packages..."
safe_exec "Docker installation" sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Configure Docker group for non-root access
log_info "Configuring Docker group for non-root usage..."
sudo groupadd docker 2>/dev/null || log_skip "Docker group already exists"
safe_exec "Add user to docker group" sudo usermod -aG docker "$USER"

# IMPORTANT: Docker group changes require logout/login or system restart to take effect
# The 'newgrp docker' command would create a new shell session and block the script
log_warn "Docker group added. You need to LOG OUT and LOG BACK IN for docker group to take effect."
log_warn "Alternatively, reboot your system or run: sudo systemctl restart docker"

################################################################################
# SYSTEM TOOLS
################################################################################

log_section "Installing System Tools"

# ImageMagick: Image manipulation tool
log_info "Installing ImageMagick..."
safe_exec "imagemagick" sudo apt install -y imagemagick

# Mainline: Kernel update tool
log_info "Installing Mainline kernel tool..."
safe_exec "PPA cappelikan" sudo add-apt-repository ppa:cappelikan/ppa -y
safe_exec "apt update for mainline" sudo apt update
# FIX: Add -y flag to full-upgrade for non-interactive execution
safe_exec "apt full-upgrade" sudo apt full-upgrade -y
safe_exec "mainline" sudo apt install -y mainline

# GCC-14: Latest GCC compiler
log_info "Installing GCC-14..."
safe_exec "universe repository" sudo add-apt-repository universe -y
safe_exec "gcc-14" sudo apt install -y gcc-14

# Tig: Text-mode interface for Git
log_info "Installing tig..."
safe_exec "tig" sudo apt-get install -y tig

# gh
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
sudo apt update -y
sudo apt install gh -y
gh extension install dlvhdr/gh-dash

# terraform
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform

# Packer
# https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer

# Return to home directory
cd "$HOME" || exit

################################################################################
# INSTALLATION COMPLETE
################################################################################

log_section "Installation Complete!"
log_success "All packages and tools have been installed."
log_info ""
log_info "NEXT STEPS:"
log_info "1. Run 'make init' to set up dotfile symlinks"
log_info "2. LOG OUT and LOG BACK IN for Docker group and shell changes to take effect"
log_info "3. Restart your terminal or run: source ~/.zshrc"
log_info "4. (Optional) Install Tmux plugins: Press Ctrl+A then I in tmux"
log_info ""
log_warn "Important: Some tools require a logout/login to work properly!"
echo ""

