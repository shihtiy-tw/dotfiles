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
    #
    # UV_NO_MODIFY_PATH=1 is not optional here. Left to itself the installer appends
    # `. "$HOME/.local/bin/env"` to ~/.zshrc - and init.sh symlinks that file into this
    # repo, so `make llm` used to leave the checkout dirty. Caught by the container
    # harness's repo_dirty step. The line is redundant anyway: zsh/env.zsh:37 already puts
    # ~/.local/bin on PATH. (The `--no-modify-path` flag is deprecated upstream in favour
    # of this variable.)
    curl -fsSL https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
}

if command_exists uv; then
    log_skip "uv already installed"
elif [[ "$(detect_platform)" == "termux" ]]; then
    # Astral publishes no x86_64-linux-android build; the installer says so itself
    # ("there isn't a download for your platform x86_64-linux-android"). Termux packages uv
    # separately, so try that before giving up. Not routed through safe_exec: a failure here
    # means "unavailable on this platform", which should not be counted against the run.
    if pkg_install uv; then
        log_success "Installed uv from termux-main"
    else
        record_unsupported "uv" "no Android build from astral.sh, and pkg install uv failed"
    fi
    [[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
else
    safe_exec "uv" install_uv
    # The installer cannot change this shell's PATH, so pick it up for the steps below.
    [[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
fi

################################################################################
# llm
################################################################################

# https://github.com/simonw/llm
#
# `--with httpx` is load-bearing. llm 0.32 depends on openai 3.x, which now depends on the
# renamed `httpx2` distribution, but llm's own models.py still does a bare `import httpx`
# without declaring it - so a stock `uv tool install llm` produces a binary that tracebacks
# with ModuleNotFoundError on every invocation, `llm --version` included. Naming httpx
# explicitly puts it in the tool's environment. Verified in a container: without it `llm
# --version` fails, with it llm 0.32 runs and `llm install llm-ollama` succeeds. Harmless
# once upstream declares the dependency properly.
#
# The interpreter is pinned separately, for reproducibility rather than for this bug: left
# alone, uv resolved llm 0.32 on Ubuntu/Arch and llm 0.27.1 on Amazon Linux, whose system
# python3 is 3.9. Pinning is NOT what fixes the import - the container run confirmed 3.12
# resolves httpx2 exactly like 3.14 does.
# Not pinned on Termux: uv can only satisfy --python by downloading a managed CPython, and
# Astral publishes none for Android, so the pin turns into "No interpreter found for Python
# 3.12 in managed installations or search path". Use whatever python Termux has.
if [[ "$(detect_platform)" == "termux" ]]; then
    LLM_PYTHON=""
else
    LLM_PYTHON="${LLM_PYTHON:-3.12}"
fi

install_llm() {
    if [[ -n "$LLM_PYTHON" ]]; then
        uv tool install --python "$LLM_PYTHON" --with httpx llm || return 1
    else
        uv tool install --with httpx llm || return 1
    fi
    [[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
    # An install that cannot be run is not an install. Without this check the failure
    # surfaced one step later as "llm-ollama plugin failed", pointing at the wrong thing.
    llm --version > /dev/null 2>&1
}

if command_exists llm && llm --version > /dev/null 2>&1; then
    log_skip "llm already installed ($(llm --version 2>&1))"
elif [[ "$(detect_platform)" == "termux" ]] && command_exists uv && ! command_exists cargo; then
    # llm -> openai -> jiter, and jiter publishes no Android wheel, so uv falls back to
    # building it: "Rust not found, installing into a temporary directory" and then
    # "Target triple not supported by rustup: x86_64-unknown-linux-android". Same shape as
    # parllama/tiktoken in install-tui.sh. `pkg install rust` first if you want to try.
    record_unsupported "llm" \
        "its jiter dependency ships no Android wheel and needs a Rust compiler"
elif command_exists uv; then
    safe_exec "llm${LLM_PYTHON:+ (python $LLM_PYTHON)}" install_llm
    [[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
elif [[ "$(detect_platform)" == "termux" ]]; then
    record_unsupported "llm" "requires uv, which has no Android build"
else
    record_failure "llm (uv unavailable)"
fi

# Plugin lives in llm's own virtualenv, so it goes through `llm install`, not uv/pip.
# `llm --version` is retested rather than just `command_exists`: a broken install leaves the
# wrapper script on PATH, so command_exists alone would send us into a plugin install that
# can only traceback.
if command_exists llm && llm --version > /dev/null 2>&1; then
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

# `2>&1` in a version probe is a trap: when the tool is installed but broken, it prints a
# whole Python traceback into what is meant to be a one-line summary. Ask for the version,
# and if it cannot answer, say that instead.
if command_exists llm; then
    if llm --version > /dev/null 2>&1; then
        log_info "llm: $(llm --version 2>/dev/null)"
    else
        log_warn "llm: on PATH but not runnable"
        log_warn "  try: uv tool install${LLM_PYTHON:+ --python $LLM_PYTHON} --force --with httpx llm"
    fi
fi
if command_exists gemini; then
    if gemini --version > /dev/null 2>&1; then
        log_info "gemini: $(gemini --version 2>/dev/null | head -1)"
    else
        log_warn "gemini: on PATH but not runnable"
    fi
fi

install_summary
