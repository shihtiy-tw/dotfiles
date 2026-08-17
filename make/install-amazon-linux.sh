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

# wget: used further down for diff-so-fancy and the Neovim AppImage. Amazon Linux 2023
# ships only curl-minimal, so both calls died with "wget: command not found" - and
# neither is wrapped in safe_exec, so the script logged success for tools it had not
# installed.
#
# libatomic: current official node linux-x64 builds link against libatomic.so.1, which
# AL2023 does not install by default. Without it nvm's node cannot execute at all,
# taking node, npm and vibe-kanban with it.
safe_exec "wget" sudo yum install -y wget
safe_exec "libatomic" sudo yum install -y libatomic

################################################################################
# PYTHON
################################################################################

log_section "Installing Python"

# This block used to be wrapped in `if [ "$HOME" = "/root" ]`, which made it dead code
# for every ordinary user - so python3-pip was never installed and every later `pip3`
# call failed with "command not found".
#
# The quotes on 'python3*' matter: unquoted, the shell expands the glob against the
# current directory before yum ever sees it.
safe_exec "Python3 packages" sudo yum -y install 'python3*'
safe_exec "pip3" sudo yum -y install python3-pip

# No EPEL here. This was pinned to epel-release-latest-7 (wrong on AL2023, which is el9),
# and deriving the major version does not help either: `rpm -E %{rhel}` returns the
# literal string "%{rhel}" on Amazon Linux because the macro is undefined, and AL2023
# publishes no epel-release package at all. Anything that genuinely needs EPEL has to
# come from source or from the AL2023 repos.

# pyenv. The module was sourced at the top of this script but never called, so pyenv was
# silently absent on Amazon Linux - which also left the Python build dependencies above
# with nothing to build.
safe_exec "pyenv" install_pyenv

################################################################################
# SHELL CONFIGURATION
################################################################################

log_section "Shell Configuration"

# zsh
safe_exec "Zsh" sudo yum install zsh -y

# Oh-My-Zsh: Using shared module
safe_exec "oh-my-zsh" install_oh_my_zsh

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
safe_exec "tmux plugin manager" install_tmux_tpm

# vim
safe_exec "Vim" sudo yum install vim -y

# diff-so-fancy
log_info "Installing diff-so-fancy..."
if [ ! -f /usr/local/bin/diff-so-fancy ]; then
    # curl -f, and only report success if the download actually happened. This used to
    # call wget - absent on AL2023 - outside safe_exec, then log success unconditionally,
    # so the log claimed diff-so-fancy was installed when nothing had been downloaded.
    dsf_tmp="$(mktemp -d)"
    if curl -fsSL -o "$dsf_tmp/diff-so-fancy" \
        https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy; then
        safe_exec "diff-so-fancy install" \
            sudo install -m 0755 "$dsf_tmp/diff-so-fancy" /usr/local/bin/diff-so-fancy
    else
        log_error "Failed to download diff-so-fancy"
    fi
    rm -rf "$dsf_tmp"
else
    log_skip "diff-so-fancy already installed"
fi

################################################################################
# NODE.JS
################################################################################

log_section "Installing Node.js"

# NVM and Node.js using shared module
safe_exec "NVM and Node.js" install_nvm_with_node

# Bun - Using shared module
safe_exec "Bun" install_bun

# Language servers
# No sudo on these. npm here comes from nvm, which lives under ~/.nvm - and sudo resets
# PATH to secure_path, so `sudo npm` failed with "sudo: npm: command not found" while the
# `command -v npm` guard above passed on the user's own PATH.
if command -v npm &> /dev/null; then
    safe_exec "bash-language-server" npm install -g --prefix "$HOME/.local" bash-language-server
    safe_exec "markdownlint-cli" npm install -g --prefix "$HOME/.local" markdownlint-cli
fi

################################################################################
# ADDITIONAL TOOLS
################################################################################

log_section "Installing Additional Tools"

safe_exec "iperf3" sudo yum install -y iperf3
safe_exec "jq" sudo yum install -y jq
safe_exec "atop" sudo yum install -y atop

# hping3 needs EPEL, which Amazon Linux 2023 does not have (see the Python section).
# amazon-linux-extras is an AL2-only tool, so probe for it rather than shelling out to a
# command that does not exist - the old `if sudo amazon-linux-extras list | grep -q epel`
# just printed "sudo: amazon-linux-extras: command not found" and fell through silently.
if command -v amazon-linux-extras &> /dev/null; then
    safe_exec "EPEL extras" sudo amazon-linux-extras install epel -y
    safe_exec "hping3" sudo yum install -y hping3 || true
else
    log_skip "hping3 (needs EPEL, unavailable on this release)"
fi

################################################################################
# NEOVIM
################################################################################

log_section "Installing Neovim"

if ! command -v nvim &> /dev/null; then
    log_info "Installing Neovim from AppImage..."
    # Upstream renamed the asset to include the architecture; plain nvim.appimage is now
    # a 404. curl -f (not wget) so an error page cannot be installed as the editor, and
    # `install` only after a successful download - the old `sudo rm -f /usr/bin/nvim` ran
    # before the move, so a failed download deleted a working nvim and left nothing.
    case "$(uname -m)" in
        x86_64) nvim_appimage="nvim-linux-x86_64.appimage" ;;
        aarch64 | arm64) nvim_appimage="nvim-linux-arm64.appimage" ;;
        *) nvim_appimage="" ;;
    esac

    if [ -z "$nvim_appimage" ]; then
        log_error "No Neovim AppImage published for $(uname -m)"
    else
        nvim_tmp="$(mktemp -d)"
        if curl -fsSL -o "$nvim_tmp/nvim" \
            "https://github.com/neovim/neovim/releases/latest/download/$nvim_appimage"; then
            safe_exec "Neovim install" sudo install -m 0755 "$nvim_tmp/nvim" /usr/bin/nvim
        else
            log_error "Failed to download Neovim AppImage ($nvim_appimage)"
        fi
        rm -rf "$nvim_tmp"
    fi
else
    log_skip "Neovim already installed"
fi

# Python providers
pip3 install pynvim --user || true
if command -v npm &> /dev/null; then
    npm install -g --prefix "$HOME/.local" neovim || true
fi

################################################################################
# FZF & AUTOJUMP
################################################################################

log_section "Installing FZF and Autojump"

safe_exec "FZF" install_fzf
safe_exec "autojump" install_autojump

################################################################################
# AI TOOLS
################################################################################

log_section "Installing AI Tools"

# Agent Deck: AI workspace manager - Using shared module
safe_exec "Agent Deck" install_agent_deck

# Vibe Kanban: AI-native kanban - Using shared module
safe_exec "Vibe Kanban" install_vibe_kanban

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

# the_silver_searcher only exists in EPEL, and epel-release.noarch is not a package on
# AL2023 either. ripgrep covers the same ground and is in the AL2023 repos.
safe_exec "ripgrep" sudo yum install -y ripgrep || true

################################################################################
# COMPLETION
################################################################################

log_section "Installation Complete"

cd "$HOME" || true

echo ""
log_info "Next steps:"
echo "  1. Run 'make init' to create symlinks"
echo "  2. Log out and back in for group changes"
echo "  3. Run 'chsh -s \$(which zsh)' to set Zsh as default shell"
echo ""

# Exit non-zero if any step failed. Without this the script returned 0 no matter what -
# a run with ten broken installs was indistinguishable from a clean one, so `make
# install` could never be used as a gate.
install_summary
exit $?
