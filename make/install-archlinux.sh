#!/bin/bash
################################################################################
# Arch Linux Development Environment Setup Script
#
# Description: Automated installation of development tools for Arch Linux
# Author: shihtiy-tw
# Platforms: Arch Linux
# Last Updated: 2026-02-01
#
# Reference: https://github.com/silentz/arch-linux-install-guide
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
source "$SCRIPT_DIR/modules/common/gitflow.sh"
source "$SCRIPT_DIR/modules/common/fzf.sh"
source "$SCRIPT_DIR/modules/common/bun.sh"
source "$SCRIPT_DIR/modules/common/agent-deck.sh"
source "$SCRIPT_DIR/modules/common/vibe-kanban.sh"

################################################################################
# HEADLESS MODE
################################################################################

# Set DOTFILES_HEADLESS=1 to skip desktop applications, the display manager, and
# host-hardware drivers. None of them are usable on a server, in a VM guest, or in
# a container - and together they account for well over 10GB of downloads plus DKMS
# module builds against a kernel that may not even be running.
#
# Everything else (shells, editors, languages, CLI tooling) still installs.
DOTFILES_HEADLESS="${DOTFILES_HEADLESS:-0}"

# Usage: if headless_skip "GTK themes"; then ... fi   <- true means "skip this"
headless_skip() {
    if [ "$DOTFILES_HEADLESS" = "1" ]; then
        log_skip "$1 (DOTFILES_HEADLESS=1)"
        return 0
    fi
    return 1
}

if [ "$DOTFILES_HEADLESS" = "1" ]; then
    log_warn "DOTFILES_HEADLESS=1: skipping GUI apps, display manager, and hardware drivers"
fi

################################################################################
# SYSTEM UTILITIES
################################################################################

log_section "Installing System Utilities"

# Core utilities
safe_exec "dbus" sudo pacman --noconfirm -S dbus
# CPU microcode is loaded by the bootloader for the physical host, so it does nothing
# in a container or VM guest.
headless_skip "intel-ucode" || safe_exec "intel-ucode" sudo pacman --noconfirm -S intel-ucode
safe_exec "fuse2" sudo pacman --noconfirm -S fuse2
safe_exec "lshw" sudo pacman --noconfirm -S lshw
safe_exec "powertop" sudo pacman --noconfirm -S powertop
safe_exec "inxi" sudo pacman --noconfirm -S inxi
safe_exec "acpi" sudo pacman --noconfirm -S acpi

# Build essentials
safe_exec "base-devel" sudo pacman --noconfirm -S base-devel
safe_exec "git" sudo pacman --noconfirm -S git git-lfs
safe_exec "zip unzip" sudo pacman --noconfirm -S zip unzip p7zip
safe_exec "htop" sudo pacman --noconfirm -S htop
safe_exec "tree" sudo pacman --noconfirm -S tree
safe_exec "dialog" sudo pacman --noconfirm -S dialog
safe_exec "reflector" sudo pacman --noconfirm -S reflector
safe_exec "bash-completion" sudo pacman --noconfirm -S bash-completion

# zsh itself. archlinux:base does not ship it, and this script was installing oh-my-zsh,
# seven zsh plugins and the spaceship theme, symlinking ~/.zshrc, then printing a hint to
# run `chsh -s $(which zsh)` - on a machine where zsh did not exist.
safe_exec "zsh" sudo pacman --noconfirm -S zsh zsh-completions

# Network tools
safe_exec "network tools" sudo pacman --noconfirm -S iw wpa_supplicant tcpdump mtr net-tools
safe_exec "conntrack" sudo pacman --noconfirm -S conntrack-tools ethtool wget rsync
safe_exec "socat netcat" sudo pacman --noconfirm -S socat openbsd-netcat axel bind
safe_exec "less vi" sudo pacman --noconfirm -S less vi

################################################################################
# SYSTEM CONFIGURATION
################################################################################

log_section "System Configuration"

# Fonts (kept in headless mode: terminus-font is a console font, and the rest are
# tiny and harmless)
safe_exec "fonts" sudo pacman --noconfirm -S ttf-dejavu ttf-freefont ttf-liberation ttf-droid terminus-font
safe_exec "noto fonts" sudo pacman --noconfirm -S noto-fonts noto-fonts-emoji ttf-ubuntu-font-family ttf-roboto ttf-roboto-mono ttf-ibm-plex

# Everything below this point drives a display, a speaker, a printer, a battery or a
# GPU. On a headless machine it is dead weight, and the systemctl enable calls fail
# anyway without a running systemd.
if ! headless_skip "desktop and hardware configuration"; then
    # Session manager
    log_info "Enabling session manager..."
    safe_exec "ly" sudo pacman --noconfirm -S ly
    sudo systemctl enable ly || true

    # Sound support
    safe_exec "alsa" sudo pacman --noconfirm -S alsa-utils alsa-plugins
    safe_exec "sof-firmware" sudo pacman --noconfirm -S sof-firmware

    # Bluetooth
    safe_exec "bluetooth" sudo pacman --noconfirm -S bluez bluez-utils blueman
    sudo systemctl enable bluetooth || true

    # Printing
    safe_exec "cups" sudo pacman --noconfirm -S cups cups-filters cups-pdf system-config-printer
    safe_exec "hplip" sudo pacman --noconfirm -S hplip
    sudo systemctl enable cups.service || true

    # Power management
    safe_exec "tlp" sudo pacman --noconfirm -S tlp tlp-rdw
    sudo systemctl enable tlp || true
    sudo systemctl enable fstrim.timer || true

    # GTK themes
    safe_exec "gtk themes" sudo pacman --noconfirm -S arc-gtk-theme adapta-gtk-theme materia-gtk-theme papirus-icon-theme

    # NetworkManager addons
    safe_exec "nm-connection-editor" sudo pacman --noconfirm -S nm-connection-editor networkmanager-openvpn

    # Graphics drivers
    safe_exec "vulkan intel" sudo pacman --noconfirm -S mesa vulkan-intel || true
    safe_exec "nvidia-utils" sudo pacman --noconfirm -S nvidia-utils || true

    # Keyboard management
    safe_exec "xorg-xmodmap" sudo pacman --noconfirm -S xorg-xmodmap xkeycaps
fi

################################################################################
# GENERAL PURPOSE APPS
################################################################################

log_section "Installing General Purpose Apps"

# CLI tools from this section - always installed.
safe_exec "rclone" sudo pacman --noconfirm -S rclone
safe_exec "openvpn wireguard" sudo pacman --noconfirm -S openvpn wireguard-tools

# Desktop applications. This is the single biggest download in the script
# (libreoffice, gimp, inkscape, obs-studio, vlc and firefox alone are several GB) and
# none of it can be launched without a display server.
if ! headless_skip "desktop applications"; then
    safe_exec "firefox" sudo pacman --noconfirm -S firefox
    safe_exec "obsidian" sudo pacman --noconfirm -S obsidian
    safe_exec "bitwarden" sudo pacman --noconfirm -S bitwarden bitwarden-cli
    safe_exec "mousepad" sudo pacman --noconfirm -S mousepad
    safe_exec "file-roller" sudo pacman --noconfirm -S file-roller
    safe_exec "evince" sudo pacman --noconfirm -S evince
    safe_exec "xournalpp" sudo pacman --noconfirm -S xournalpp
    safe_exec "libreoffice" sudo pacman --noconfirm -S libreoffice
    safe_exec "gimp" sudo pacman --noconfirm -S gimp
    safe_exec "gpick" sudo pacman --noconfirm -S gpick
    safe_exec "inkscape" sudo pacman --noconfirm -S inkscape
    safe_exec "fontforge" sudo pacman --noconfirm -S fontforge
    safe_exec "gparted" sudo pacman --noconfirm -S gparted
    safe_exec "vlc" sudo pacman --noconfirm -S vlc
    safe_exec "remmina" sudo pacman --noconfirm -S remmina
    safe_exec "shotcut" sudo pacman --noconfirm -S shotcut
    safe_exec "evolution" sudo pacman --noconfirm -S evolution
    safe_exec "redshift" sudo pacman --noconfirm -S redshift
    safe_exec "obs-studio" sudo pacman --noconfirm -S obs-studio
    safe_exec "wireshark-qt" sudo pacman --noconfirm -S wireshark-qt
    safe_exec "spotify-launcher" sudo pacman --noconfirm -S spotify-launcher
    safe_exec "telegram-desktop" sudo pacman --noconfirm -S telegram-desktop
    safe_exec "arandr" sudo pacman --noconfirm -S arandr
fi

################################################################################
# YAY (AUR HELPER)
################################################################################

log_section "Installing YAY (AUR Helper)"

if ! command -v yay &> /dev/null; then
    log_info "Installing yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm) || log_error "yay installation failed"
    rm -rf /tmp/yay
    log_success "yay installed"
else
    log_skip "yay already installed"
fi

# Install one AUR package.
#
# The -S is not optional. `yay <pkg>` with no operation is yay's *interactive search*
# mode: it prints a numbered list of matches and waits for you to type numbers. Piping
# `yes` into that feeds it "y", which is not a number, so yay printed "there is nothing
# to do" and exited 0 - and every AUR package here silently installed nothing while the
# log claimed otherwise.
#
# No `yes |` either: --noconfirm plus the three --answer* flags is already
# non-interactive, and the pipe both hid the real exit status and tripped `pipefail`
# when yay exited before `yes` was done writing.
#
# yay resolves the official repos first, so packages that have since graduated out of the
# AUR (lazygit, lazydocker, aws-cli-v2, kind) get the signed binary package for free.
aur_install() {
    local pkg="$1"
    log_info "Installing $pkg from AUR..."
    if LANG=C yay -S --noconfirm \
        --answerdiff None --answerclean None --answeredit None \
        --mflags "--noconfirm" "$pkg"; then
        log_success "$pkg installed"
        return 0
    fi
    log_warn "Failed to install $pkg"
    return 1
}

################################################################################
# DEVELOPMENT TOOLS
################################################################################

log_section "Installing Development Tools"

safe_exec "neovim" sudo pacman --noconfirm -S neovim
headless_skip "zed editor" || safe_exec "zed" sudo pacman --noconfirm -S zed || true
safe_exec "tree-sitter" sudo pacman --noconfirm -S tree-sitter tree-sitter-cli
safe_exec "stow" sudo pacman --noconfirm -S stow
safe_exec "sqlite3" sudo pacman --noconfirm -S sqlite
safe_exec "tldr" sudo pacman --noconfirm -S tldr
safe_exec "jq" sudo pacman --noconfirm -S jq
safe_exec "tmux" sudo pacman --noconfirm -S tmux
safe_exec "nmap masscan" sudo pacman --noconfirm -S nmap masscan
safe_exec "pgcli" sudo pacman --noconfirm -S pgcli
safe_exec "redis" sudo pacman --noconfirm -S redis
safe_exec "apache" sudo pacman --noconfirm -S apache
headless_skip "meld" || safe_exec "meld" sudo pacman --noconfirm -S meld
safe_exec "websocat" sudo pacman --noconfirm -S websocat
safe_exec "sshpass" sudo pacman --noconfirm -S sshpass
safe_exec "git-filter-repo" sudo pacman --noconfirm -S git-filter-repo

# IaC & DevOps
safe_exec "ansible" sudo pacman --noconfirm -S ansible
safe_exec "terraform" sudo pacman --noconfirm -S terraform
safe_exec "packer" sudo pacman --noconfirm -S packer

################################################################################
# CONTAINERS & KUBERNETES
################################################################################

log_section "Installing Container Tools"

safe_exec "podman" sudo pacman --noconfirm -S podman podman-compose
safe_exec "docker" sudo pacman --noconfirm -S docker docker-compose docker-buildx

# Kubernetes
safe_exec "kubectl" sudo pacman --noconfirm -S kubectl
safe_exec "helm" sudo pacman --noconfirm -S helm
safe_exec "kubeadm" sudo pacman --noconfirm -S kubeadm
safe_exec "kustomize" sudo pacman --noconfirm -S kustomize
safe_exec "k9s" sudo pacman --noconfirm -S k9s

# AUR: kind
if command -v yay &> /dev/null; then
    aur_install kind || true
fi

# Docker configuration
log_info "Configuring Docker..."
sudo systemctl enable docker || true
sudo usermod -a -G docker "${USER:-$(id -un)}" || true
# NOTE: newgrp docker is NOT used here as it blocks the script
log_warn "Docker group added. You must LOG OUT and back in for docker group to take effect."

################################################################################
# PROGRAMMING LANGUAGES
################################################################################

log_section "Installing Programming Languages"

# Go
safe_exec "go" sudo pacman --noconfirm -S go
if command -v go &> /dev/null; then
    go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest || true
    go install github.com/hairyhenderson/gomplate/v4/cmd/gomplate@latest || true
fi

# Ruby
safe_exec "ruby" sudo pacman --noconfirm -S ruby ruby-webrick

# Java
safe_exec "jdk8" sudo pacman --noconfirm -S jdk8-openjdk
safe_exec "jdk11" sudo pacman --noconfirm -S jdk11-openjdk
safe_exec "jdk17" sudo pacman --noconfirm -S jdk17-openjdk
safe_exec "jdk21" sudo pacman --noconfirm -S jdk21-openjdk
safe_exec "jdk-openjdk" sudo pacman --noconfirm -S jdk-openjdk
safe_exec "maven gradle" sudo pacman --noconfirm -S maven gradle

# C/C++
safe_exec "gcc gdb clang" sudo pacman --noconfirm -S gcc gdb clang
safe_exec "cmake ninja" sudo pacman --noconfirm -S cmake ninja
# ~5GB and useless without an NVIDIA GPU passed through.
headless_skip "cuda" || safe_exec "cuda" sudo pacman --noconfirm -S cuda || true
safe_exec "nasm boost" sudo pacman --noconfirm -S nasm boost

# Python
safe_exec "python" sudo pacman --noconfirm -S python python-pip python-poetry
safe_exec "pyenv" sudo pacman --noconfirm -S pyenv
safe_exec "uv" sudo pacman --noconfirm -S uv
safe_exec "pipx" sudo pacman --noconfirm -S python-pipx

# Lua
safe_exec "lua" sudo pacman --noconfirm -S lua

# JavaScript/Node
safe_exec "nodejs npm yarn" sudo pacman --noconfirm -S nodejs npm yarn

# Rust
safe_exec "rust" sudo pacman --noconfirm -S rust

# NVM for Node version management - using shared module
safe_exec "NVM and Node.js" install_nvm_with_node

# Bun - Using shared module
safe_exec "Bun" install_bun

################################################################################
# VIRTUALIZATION
################################################################################

log_section "Installing Virtualization Tools"

# qemu-full is ~2GB, virtualbox-host-dkms compiles kernel modules against the running
# kernel (which a container does not own), and wine needs a display server.
if ! headless_skip "virtualization and wine"; then
    safe_exec "cdrtools qemu" sudo pacman --noconfirm -S cdrtools qemu-full
    safe_exec "virtualbox" sudo pacman --noconfirm -S linux-headers virtualbox-host-dkms virtualbox || true

    # Wine
    safe_exec "wine" sudo pacman --noconfirm -S wine wine-mono wine-gecko winetricks zenity
fi

################################################################################
# AUR PACKAGES
################################################################################

log_section "Installing AUR Packages"

if command -v yay &> /dev/null; then
    # CLI packages - always installed.
    AUR_PACKAGES=(
        "aws-cli-v2"
        "aws-session-manager-plugin"
        "lazydocker"
        "lazygit"
        "amazon-q-bin"
    )

    # GUI packages. claude-desktop in particular is a from-source Electron build that
    # takes a long time and cannot run without a display.
    if ! headless_skip "AUR desktop applications"; then
        AUR_PACKAGES+=(
            "google-chrome"
            "sublime-text-4"
            "claude-desktop"
        )
    fi

    for pkg in "${AUR_PACKAGES[@]}"; do
        aur_install "$pkg" || true
    done
else
    log_warn "yay not available, skipping AUR packages"
fi

################################################################################
# CLI TOOLS
################################################################################

log_section "Installing CLI Tools"

safe_exec "ripgrep" sudo pacman --noconfirm -S ripgrep
safe_exec "the_silver_searcher" sudo pacman --noconfirm -S the_silver_searcher
safe_exec "tig" sudo pacman --noconfirm -S tig
safe_exec "xclip" sudo pacman --noconfirm -S xclip
safe_exec "diff-so-fancy" sudo pacman --noconfirm -S diff-so-fancy
safe_exec "shellcheck" sudo pacman --noconfirm -S shellcheck
safe_exec "powerline" sudo pacman --noconfirm -S powerline
safe_exec "github-cli" sudo pacman --noconfirm -S github-cli
safe_exec "bats" sudo pacman --noconfirm -S bats
safe_exec "yazi" sudo pacman --noconfirm -S yazi
# GUI terminal emulators. A container or server already has a terminal; these need a
# display server to open a window in.
if ! headless_skip "GUI terminal emulators"; then
    safe_exec "ghostty" sudo pacman --noconfirm -S ghostty
    safe_exec "kitty" sudo pacman --noconfirm -S kitty
fi

# System monitoring
safe_exec "monitoring tools" sudo pacman --noconfirm -S sysstat iotop iftop atop nvtop

# Man pages
safe_exec "man-db" sudo pacman --noconfirm -S man-db man-pages
sudo mandb || true

################################################################################
# SHELL CONFIGURATION
################################################################################

log_section "Shell Configuration"

# Autojump - using shared module
safe_exec "autojump" install_autojump

# Oh-My-Zsh - using shared module
safe_exec "oh-my-zsh" install_oh_my_zsh

# Tmux TPM - using shared module
safe_exec "tmux plugin manager" install_tmux_tpm

# Gitflow - using shared module
safe_exec "git-flow" install_gitflow

# FZF - using shared module
safe_exec "FZF" install_fzf

################################################################################
# AI TOOLS
################################################################################

log_section "Installing AI Tools"

# Agent Deck: AI workspace manager - Using shared module
safe_exec "Agent Deck" install_agent_deck

# Vibe Kanban: AI-native kanban - Using shared module
safe_exec "Vibe Kanban" install_vibe_kanban

################################################################################
# INPUT METHODS
################################################################################

log_section "Installing Input Methods"

# An input method framework needs a display server to feed. Nothing to type into on a
# server or in a container.
if ! headless_skip "input methods"; then
    safe_exec "fcitx5" sudo pacman --noconfirm -S fcitx5 fcitx5-configtool fcitx5-rime rime-bopomofo
fi

################################################################################
# MISCELLANEOUS
################################################################################

log_section "Installing Miscellaneous Tools"

safe_exec "darkman" sudo pacman --noconfirm -S darkman
safe_exec "plantuml" sudo pacman --noconfirm -S plantuml

# ollama-cuda pulls cuda, opencl-nvidia and gcc15 as hard dependencies: ~3GB downloaded,
# ~6GB installed. Without this gate it re-imported the very cuda that the gate at the
# CUDA section had just skipped. Headless hosts get the CPU build instead, which is the
# same binary minus the GPU backend.
if headless_skip "ollama CUDA backend"; then
    safe_exec "ollama" sudo pacman --noconfirm -S ollama || true
else
    safe_exec "ollama-cuda" sudo pacman --noconfirm -S ollama-cuda || true
fi

# Display-server clients. Every one of these needs an X or Wayland session to open a
# window; arch-wiki-docs alone is 225MB of HTML.
if ! headless_skip "miscellaneous desktop applications"; then
    safe_exec "flameshot" sudo pacman --noconfirm -S flameshot
    safe_exec "discord" sudo pacman --noconfirm -S discord
    safe_exec "calibre" sudo pacman --noconfirm -S calibre
    safe_exec "qt5-tools" sudo pacman --noconfirm -S qt5-tools
    safe_exec "remote desktop" sudo pacman --noconfirm -S rdesktop freerdp
    safe_exec "arch-wiki-docs" sudo pacman --noconfirm -S arch-wiki-docs
fi

# Nerd fonts
log_info "Installing Nerd Fonts..."
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash || true
safe_exec "otf-codenewroman-nerd" sudo pacman --noconfirm -S otf-codenewroman-nerd

################################################################################
# COMPLETION
################################################################################

log_section "Installation Complete"

cd "$HOME" || true

echo ""
log_info "Next steps:"
echo "  1. Run 'make init' to create dotfile symlinks"
echo "  2. LOG OUT and back in for docker group to take effect"
echo "  3. Set default shell: chsh -s \$(which zsh)"
echo "  4. Configure masscan: sudo setcap 'cap_net_raw+epi' /usr/bin/masscan"
echo "  5. Switch JVM: archlinux-java set VERSION"
echo ""
log_warn "Some packages may require manual configuration - check their documentation."
echo ""

# Exit non-zero if any step failed. Without this the script returned 0 no matter what -
# a run with ten broken installs was indistinguishable from a clean one, so `make
# install` could never be used as a gate.
install_summary
exit $?
