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
elif command_exists uv; then
    safe_exec "parllama" uv tool install parllama
else
    log_warn "uv not installed - skipping parllama (run make/install-llm.sh first)"
fi

################################################################################
# GitHub CLI + gh-dash
################################################################################

# This was `sudo pacman -S --noconfirm github-cli`, hardcoded, so the script could only
# ever work on Arch despite being the generic TUI installer. The package name also differs
# per distro. Both install-ubuntu.sh and install-archlinux.sh already install gh as part of
# `make install`, so most of the time this is a no-op.
install_gh() {
    case "$(pkg_manager)" in
        pacman) pkg_install github-cli ;;
        apt | dnf | yum | brew) pkg_install gh ;;
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
