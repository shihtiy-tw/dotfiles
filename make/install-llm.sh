#!/bin/bash
################################################################################
# LLM Tooling Installation Script
#
# Description: Install Simon Willison's `llm` (with the Ollama plugin) and the
#              Google Gemini CLI
# Platforms: Debian/Ubuntu, Arch, Amazon Linux / RHEL / Fedora, macOS
# Usage: ./make/install-llm.sh   (or `make llm`)
################################################################################

set -u
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/modules/helpers/logger.sh"
source "$SCRIPT_DIR/modules/helpers/pkg.sh"

log_section "LLM Tooling"

# The default local model, used only if Ollama already has it pulled. Override with
# LLM_DEFAULT_MODEL=... to pick a different one.
LLM_DEFAULT_MODEL="${LLM_DEFAULT_MODEL:-deepseek-r1:1.5b}"

ensure_cmds curl

################################################################################
# uv
################################################################################

# `uv tool install llm` was the first line of this script, with nothing checking that uv
# exists - so on any machine without it the whole file failed immediately with "uv:
# command not found".
install_uv() {
    # Installs to ~/.local/bin, which zsh/env.zsh:37 already has on PATH.
    curl -fsSL https://astral.sh/uv/install.sh | sh
}

if command_exists uv; then
    log_skip "uv already installed"
else
    safe_exec "uv" install_uv
    # The installer cannot change this shell's PATH, so pick it up for the steps below.
    [[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
fi

################################################################################
# llm
################################################################################

if command_exists llm; then
    log_skip "llm already installed ($(llm --version 2>&1))"
elif command_exists uv; then
    # https://github.com/simonw/llm
    safe_exec "llm" uv tool install llm
    [[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
else
    record_failure "llm (uv unavailable)"
fi

# Plugin lives in llm's own virtualenv, so it goes through `llm install`, not uv/pip.
if command_exists llm; then
    if llm plugins 2>/dev/null | grep -q 'llm-ollama'; then
        log_skip "llm-ollama plugin already installed"
    else
        safe_exec "llm-ollama plugin" llm install llm-ollama
    fi
fi

################################################################################
# Default model
################################################################################

# `llm models default deepseek-r1:1.5b` ran unconditionally before. It only succeeds when
# Ollama is installed, its daemon is up, and that model has actually been pulled - none of
# which this script arranges. On a fresh machine it therefore always failed. Ollama is
# deliberately not installed here: it wants a system service and pulls multi-gigabyte
# weights, which is not something an unattended provisioning script should decide to do.
if ! command_exists llm; then
    :
elif ! command_exists ollama; then
    log_warn "Ollama not installed - skipping default model"
    log_warn "  install it with: curl -fsSL https://ollama.com/install.sh | sh"
    log_warn "  then: ollama pull $LLM_DEFAULT_MODEL && llm models default $LLM_DEFAULT_MODEL"
elif ! ollama list > /dev/null 2>&1; then
    log_warn "Ollama is installed but its daemon is not reachable - skipping default model"
    log_warn "  start it with: ollama serve"
elif ! ollama list 2>/dev/null | awk 'NR>1 {print $1}' | grep -qx "$LLM_DEFAULT_MODEL"; then
    log_warn "Ollama does not have $LLM_DEFAULT_MODEL pulled - skipping default model"
    log_warn "  pull it with: ollama pull $LLM_DEFAULT_MODEL"
else
    safe_exec "llm default model ($LLM_DEFAULT_MODEL)" llm models default "$LLM_DEFAULT_MODEL"
fi

################################################################################
# Gemini CLI
################################################################################

# This was `npx https://github.com/google-gemini/gemini-cli`, which does not install
# anything - npx fetches the repo and *runs* it, so the line launched an interactive CLI
# and sat there. Under an unattended run with no TTY it hangs until killed. The published
# package installs properly.
#
# --prefix "$HOME/.local" because when npm comes from a distro package its global prefix
# is /usr, so `npm i -g` EACCES-es for any non-root user.
install_gemini_cli() {
    npm install -g --prefix "$HOME/.local" @google/gemini-cli
}

if command_exists gemini; then
    log_skip "gemini CLI already installed"
elif command_exists npm; then
    safe_exec "gemini CLI" install_gemini_cli
else
    log_warn "npm not installed - skipping Gemini CLI (install Node via make install first)"
fi

################################################################################
# SUMMARY
################################################################################

command_exists llm    && log_info "llm: $(llm --version 2>&1)"
command_exists gemini && log_info "gemini: $(gemini --version 2>&1 | head -1)"

install_summary
