#!/bin/bash
################################################################################
# Terminal UI Tools Installation Script
#
# Description: Install basalt (Obsidian TUI), parllama (Ollama TUI) and gh-dash
# Platforms: Debian/Ubuntu, Arch, Amazon Linux / RHEL / Fedora, macOS
# Usage: ./make/install-tui.sh   (or `make tui`)
################################################################################

set -u
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/modules/helpers/logger.sh"
source "$SCRIPT_DIR/modules/helpers/pkg.sh"

log_section "Terminal UI Tools"

# install-llm.sh installs uv into ~/.local/bin and cargo lives in ~/.cargo/bin, but neither
# is on PATH for a non-interactive shell. Without this, running `make llm && make tui` back
# to back reported "uv not installed - skipping parllama" one step after uv was installed -
# observed on both Arch and Amazon Linux.
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"

PLATFORM="$(detect_platform)"

# gh is a Go binary, and `gh extension install` talks to api.github.com. Without a findable
# CA bundle it fails with an x509 error on Termux even though gh itself installed fine.
setup_go_tls || true

################################################################################
# basalt: Obsidian vault TUI
################################################################################

# https://github.com/erikjuhani/basalt
# Was a bare `cargo install basalt-tui` with nothing checking for cargo, so it failed with
# "cargo: command not found" on any machine where Rust had not been installed first.
if command_exists basalt; then
    log_skip "basalt already installed"
elif command_exists cargo; then
    safe_exec "basalt (Obsidian TUI)" cargo install basalt-tui
else
    log_warn "cargo not installed - skipping basalt (run 'make install' for the Rust toolchain)"
fi

################################################################################
# parllama: Ollama / LLM chat TUI
################################################################################

if command_exists parllama; then
    log_skip "parllama already installed"
elif ! command_exists uv; then
    log_warn "uv not installed - skipping parllama (run make/install-llm.sh first)"
elif [[ "$PLATFORM" == "termux" ]] && ! command_exists cargo; then
    # parllama -> par-ai-core -> tiktoken, which publishes no Android wheel, so uv falls back
    # to building it and stops with "error: can't find Rust compiler". A platform limitation,
    # not a failed install.
    record_unsupported "parllama" \
        "its tiktoken dependency ships no Android wheel and needs a Rust compiler"
else
    safe_exec "parllama" uv tool install parllama
fi

################################################################################
# GitHub CLI + gh-dash
################################################################################

# This was `sudo pacman -S --noconfirm github-cli`, hardcoded, so the script could only
# ever work on Arch despite being the generic TUI installer. Both install-ubuntu.sh and
# install-archlinux.sh already install gh as part of `make install`, so most of the time
# this is a no-op.
#
# gh is only in the distro archives on Arch, Fedora and Homebrew. It is NOT in Ubuntu's or
# Debian's, and NOT in the Amazon Linux 2023 repos - the container run confirmed both
# ("E: Unable to locate package gh" and "No match for argument: gh"), so a plain
# `pkg_install gh` was dead code on the two platforms most likely to run this. GitHub
# publishes its own repos; install-ubuntu.sh:462-469 already wires up the apt one.

install_gh_apt_repo() {
    ensure_cmds curl gpg || return 1
    as_root install -m 0755 -d /etc/apt/keyrings || return 1
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | as_root tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null || return 1
    as_root chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg || return 1
    echo "deb [arch=$(detect_arch) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | as_root tee /etc/apt/sources.list.d/github-cli.list > /dev/null || return 1
    pkg_refresh
}

install_gh_rpm_repo() {
    # Written directly rather than via `dnf config-manager --add-repo`, which lives in the
    # dnf-plugins-core package and is absent from the amazonlinux:2023 base image.
    as_root tee /etc/yum.repos.d/gh-cli.repo > /dev/null <<'EOF'
[gh-cli]
name=packages for the GitHub CLI
baseurl=https://cli.github.com/packages/rpm
enabled=1
gpgcheck=1
gpgkey=https://cli.github.com/packages/githubcli-archive-keyring.asc
EOF
}

install_gh() {
    case "$(pkg_manager)" in
        pacman)     pkg_install github-cli ;;
        brew)       pkg_install gh ;;
        pkg)        pkg_install gh ;;   # termux-main carries it
        apt)        install_gh_apt_repo && pkg_install gh ;;
        dnf | yum)  install_gh_rpm_repo && pkg_install gh ;;
        *)
            log_error "No gh package known for this platform"
            return 1
            ;;
    esac
}

if command_exists gh; then
    log_skip "gh already installed"
else
    safe_exec "GitHub CLI" install_gh
fi

# gh-dash: PR/issue dashboard. The extension is named gh-dash, not dash - the old
# `gh extension upgrade dash` therefore always failed with "extension not found", and
# upgrading immediately after a fresh install was redundant anyway.
if command_exists gh; then
    if gh extension list 2>/dev/null | grep -q 'dlvhdr/gh-dash'; then
        log_skip "gh-dash already installed"
        safe_exec "gh-dash upgrade" gh extension upgrade dlvhdr/gh-dash
    else
        safe_exec "gh-dash" gh extension install dlvhdr/gh-dash
    fi
else
    log_warn "gh unavailable - skipping gh-dash"
fi

################################################################################
# SUMMARY
################################################################################

for tool in basalt parllama gh; do
    command_exists "$tool" && log_info "$tool: present"
done

install_summary
