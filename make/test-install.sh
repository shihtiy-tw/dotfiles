#!/bin/bash
################################################################################
# Test Script - Verify All Installations
#
# This script verifies that all tools and packages have been installed correctly
# by the installation scripts. It checks for:
#   - Command availability
#   - Directory existence
#   - Configuration files
#   - Version checks
#
# Usage: ./test-install.sh [--verbose]
#
# Exit codes:
#   0 - All tests passed
#   1 - Some tests failed
#
# Every assertion is scoped to the platforms whose installer actually installs that
# tool. Previously the whole suite ran everywhere, so Amazon Linux reported 21 failures
# for tools install-amazon-linux.sh never attempts and Termux failed 57 of 61 - which
# made the exit code useless as a gate on every platform except Ubuntu.
################################################################################

set -u  # Exit on undefined variable

################################################################################
# SETUP
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source logger
source "$SCRIPT_DIR/modules/helpers/logger.sh"

# Counters
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# Parse arguments
VERBOSE=false
if [[ "${1:-}" == "--verbose" ]] || [[ "${1:-}" == "-v" ]]; then
    VERBOSE=true
fi

################################################################################
# PLATFORM DETECTION
################################################################################

# Which installer is responsible for this machine. Mirrors install-init.sh so the two
# cannot disagree about what "this platform" means.
detect_platform() {
    if [ "$(uname -s)" = "Darwin" ]; then
        echo macos
        return
    fi
    # Termux reports uname -s as Linux and has no /etc/os-release, so check it first.
    if [ "$(uname -o 2>/dev/null)" = "Android" ]; then
        echo termux
        return
    fi
    case "${PREFIX:-}" in
        */com.termux/*)
            echo termux
            return
            ;;
    esac
    if [ -r /etc/os-release ]; then
        # Sourced in the subshell created by the caller's $( ), so ID does not leak.
        # shellcheck source=/dev/null
        . /etc/os-release
        case "${ID:-}" in
            ubuntu | linuxmint) echo ubuntu ; return ;;
            amzn)               echo amzn   ; return ;;
            arch)               echo arch   ; return ;;
        esac
    fi
    echo unknown
}

PLATFORM="$(detect_platform)"

################################################################################
# ENVIRONMENT
################################################################################

# Bring the same PATH entries into scope that the interactive shell config provides.
#
# This suite runs under bash, but the tools it looks for are put on PATH by zsh/env.zsh.
# Without this, rustc / cargo / rustup / yazi / agent-deck / vibe-kanban were all reported
# missing on a machine where they were installed and working - the single largest source
# of false failures. ~/.cargo/env used to be sourced, but only in test_cargo_packages,
# which runs *after* the Rust assertions in test_programming_languages.
load_environment() {
    local d
    for d in "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/.bun/bin" \
        "${GOPATH:-$HOME/go}/bin" "/usr/local/go/bin" "$HOME/.fzf/bin" \
        "$HOME/.autojump/bin" "$HOME/.pyenv/bin"; do
        [ -d "$d" ] && case ":$PATH:" in
            *":$d:"*) ;;
            *) PATH="$d:$PATH" ;;
        esac
    done
    export PATH

    if [[ -f "$HOME/.cargo/env" ]]; then
        # shellcheck source=/dev/null
        source "$HOME/.cargo/env"
    fi

    # nvm installs node under $NVM_DIR/versions and puts nothing on PATH until a version
    # is selected. Sourcing nvm.sh alone is not enough: without `nvm use`, `node` and
    # `npm` are absent and were reported as failures on every distro.
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
        # shellcheck source=/dev/null
        \. "$NVM_DIR/nvm.sh"
        if command -v nvm >/dev/null 2>&1; then
            nvm use default >/dev/null 2>&1 || nvm use node >/dev/null 2>&1 || true
        fi
    fi
}

################################################################################
# TEST HELPERS
################################################################################

# Run a test and record result
# Usage: run_test "description" test_command args...
run_test() {
    local description="$1"
    shift

    if "$@"; then
        log_test "PASS" "$description"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        log_test "FAIL" "$description"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Run a test only on the platforms whose installer provides the tool.
# Usage: expect_on "<space separated platforms>" "description" test_command args...
#
# Anywhere else the tool is out of scope, so the result is SKIP. A skip is not a pass:
# it is counted and printed separately so the report still shows the coverage gap.
expect_on() {
    local platforms="$1" description="$2"
    shift 2

    if [[ " $platforms " == *" $PLATFORM "* ]]; then
        run_test "$description" "$@"
        return $?
    fi

    log_test "SKIP" "$description (not provided by the $PLATFORM installer)"
    TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
    return 0
}

# Record a pass/fail/skip directly, for checks that are not a single command.
record() {
    local status="$1" description="$2"
    log_test "$status" "$description"
    case "$status" in
        PASS) TESTS_PASSED=$((TESTS_PASSED + 1)) ;;
        SKIP) TESTS_SKIPPED=$((TESTS_SKIPPED + 1)) ;;
        *)    TESTS_FAILED=$((TESTS_FAILED + 1)) ;;
    esac
}

# Check if a command exists
test_command() {
    local cmd="$1"
    command -v "$cmd" >/dev/null 2>&1
}

# Pass if any one of several commands exists.
#
# Replaces `run_test "lua" ... || run_test "luarocks" ...`, which could not work: the
# first run_test had already incremented TESTS_FAILED and printed FAIL by the time the
# `||` ran, so the fallback added a second result instead of replacing the first.
test_any_command() {
    local cmd
    for cmd in "$@"; do
        command -v "$cmd" >/dev/null 2>&1 && return 0
    done
    return 1
}

# Check if a directory exists
test_directory() {
    local dir="$1"
    [[ -d "$dir" ]]
}

# Check if a file exists
test_file() {
    local file="$1"
    [[ -f "$file" ]]
}

# Assert a command exists *and* runs.
#
# `command -v nvim` is not enough. The Neovim AppImage URL changed upstream and the old
# `curl -LO` had no -f, so a 9-byte HTTP "Not Found" body was installed to
# /usr/local/bin/nvim with the execute bit set. command -v found it and this suite
# reported neovim as installed for as long as that bug existed.
test_runs() {
    local cmd="$1"
    shift
    command -v "$cmd" >/dev/null 2>&1 || return 1
    "$cmd" "$@" >/dev/null 2>&1
}

# Check command version (for verbose output)
show_version() {
    local cmd="$1"
    if $VERBOSE && command -v "$cmd" >/dev/null 2>&1; then
        echo "    Version: $("$cmd" --version 2>&1 | head -n1)"
    fi
}

################################################################################
# SYSTEM TOOLS TESTS
################################################################################

test_system_tools() {
    log_section "System Tools"

    run_test "git" test_command git
    show_version git

    run_test "curl" test_command curl
    expect_on "ubuntu arch amzn" "wget" test_command wget
    expect_on "ubuntu arch"      "tree" test_command tree
    # Only install-archlinux.sh installs htop. Ubuntu and Amazon Linux should probably
    # add it, but asserting it there reports a wishlist item as a regression.
    expect_on "arch"             "htop" test_command htop
    expect_on "ubuntu arch amzn" "tmux" test_command tmux
    show_version tmux

    expect_on "ubuntu arch amzn" "ripgrep (rg)" test_command rg
    expect_on "ubuntu arch"      "silversearcher (ag)" test_command ag
    expect_on "ubuntu arch amzn" "fzf" test_command fzf
    expect_on "ubuntu arch amzn" "tig" test_command tig
    expect_on "ubuntu arch"      "shellcheck" test_command shellcheck
}

################################################################################
# PROGRAMMING LANGUAGES TESTS
################################################################################

test_programming_languages() {
    log_section "Programming Languages"

    # Python
    expect_on "ubuntu arch amzn" "python3" test_command python3
    show_version python3
    expect_on "ubuntu arch amzn" "pip3" test_any_command pip3 pip

    # Rust. Arch installs the pacman `rust` package, which ships rustc and cargo but
    # deliberately not rustup, so rustup is an Ubuntu-only expectation.
    expect_on "ubuntu arch" "rustc (Rust compiler)" test_command rustc
    show_version rustc
    expect_on "ubuntu arch" "cargo" test_command cargo
    show_version cargo
    expect_on "ubuntu" "rustup" test_command rustup

    # Go
    expect_on "ubuntu arch amzn" "go" test_command go
    show_version go

    # Java
    expect_on "ubuntu arch" "java" test_command java
    expect_on "ubuntu arch" "javac" test_command javac

    # Ruby
    expect_on "ubuntu arch" "ruby" test_command ruby
    show_version ruby
    expect_on "ubuntu arch" "gem" test_command gem

    # Bun
    expect_on "ubuntu arch amzn" "bun" test_command bun
    show_version bun

    # Lua. Ubuntu installs luarocks (which pulls in an interpreter), Arch installs lua.
    expect_on "ubuntu arch" "lua or luarocks" test_any_command lua luajit luarocks
}

################################################################################
# NODE.JS TESTS
################################################################################

test_nodejs() {
    log_section "Node.js / NVM"

    # nvm.sh is sourced and a version selected in load_environment, before any test runs.
    expect_on "ubuntu arch amzn" "NVM directory" test_directory "${NVM_DIR:-$HOME/.nvm}"
    expect_on "ubuntu arch amzn" "nvm command" test_command nvm
    expect_on "ubuntu arch amzn" "node" test_runs node --version
    show_version node
    expect_on "ubuntu arch amzn" "npm" test_runs npm --version
    show_version npm
}

################################################################################
# SHELL TOOLS TESTS
################################################################################

test_shell_tools() {
    log_section "Shell Tools"

    expect_on "ubuntu arch amzn" "zsh" test_command zsh
    show_version zsh

    # Oh-My-Zsh
    local omz="$HOME/.oh-my-zsh"
    expect_on "ubuntu arch amzn" "Oh-My-Zsh directory" test_directory "$omz"

    local plugin
    for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions \
        zsh-vim-mode fzf-tab zsh-system-clipboard; do
        expect_on "ubuntu arch amzn" "Oh-My-Zsh: $plugin" \
            test_directory "$omz/custom/plugins/$plugin"
    done

    expect_on "ubuntu arch amzn" "Oh-My-Zsh: spaceship-prompt theme" \
        test_directory "$omz/custom/themes/spaceship-prompt"

    # Autojump
    expect_on "ubuntu arch amzn" "autojump directory" test_directory "$HOME/.autojump"
    expect_on "ubuntu arch amzn" "autojump binary" test_file "$HOME/.autojump/bin/autojump"

    # FZF
    expect_on "ubuntu arch amzn" "fzf directory" test_directory "$HOME/.fzf"
}

################################################################################
# EDITOR TESTS
################################################################################

test_editors() {
    log_section "Editors"

    # --version, not just command -v: see test_runs.
    expect_on "ubuntu arch amzn" "neovim (nvim) runs" test_runs nvim --version
    show_version nvim

    # Only install-amazon-linux.sh installs vim. Ubuntu's line is commented out
    # (install-ubuntu.sh:258) and Arch installs `vi`, not `vim`.
    expect_on "amzn" "vim" test_command vim
    expect_on "arch" "vi" test_command vi
}

################################################################################
# TMUX TESTS
################################################################################

test_tmux() {
    log_section "Tmux"

    expect_on "ubuntu arch amzn" "Tmux Plugin Manager (TPM)" \
        test_directory "$HOME/.tmux/plugins/tpm"
}

################################################################################
# GIT TOOLS TESTS
################################################################################

test_git_tools() {
    log_section "Git Tools"

    expect_on "ubuntu arch"      "git-flow" test_command git-flow
    expect_on "ubuntu arch"      "git-lfs" test_command git-lfs
    expect_on "ubuntu arch amzn" "diff-so-fancy" test_command diff-so-fancy
    expect_on "ubuntu arch"      "gh (GitHub CLI)" test_command gh

    # commit.template comes from git/gitconfig via `make init`, on every platform.
    if [ -n "$(git config --global commit.template 2>/dev/null)" ]; then
        record PASS "Git commit template configured"
    else
        record FAIL "Git commit template not configured (run 'make init')"
    fi
}

################################################################################
# PYTHON VERSION MANAGER TESTS
################################################################################

test_python_tools() {
    log_section "Python Version Manager"

    # Location depends on the installer: Ubuntu and Amazon Linux use the pyenv module,
    # which clones to ~/.pyenv; Arch installs the pacman package at /usr/bin/pyenv.
    # Asserting ~/.pyenv unconditionally failed on Arch where pyenv was working.
    if [[ " ubuntu arch amzn " == *" $PLATFORM "* ]]; then
        if command -v pyenv >/dev/null 2>&1 || [[ -x "$HOME/.pyenv/bin/pyenv" ]]; then
            record PASS "pyenv available"
        else
            record FAIL "pyenv not found (neither on PATH nor at ~/.pyenv/bin/pyenv)"
        fi
    else
        record SKIP "pyenv (not provided by the $PLATFORM installer)"
    fi

    expect_on "ubuntu arch" "pipx" test_command pipx
}

################################################################################
# CONTAINER TOOLS TESTS
################################################################################

test_container_tools() {
    log_section "Container Tools"

    expect_on "ubuntu arch" "docker" test_command docker
    show_version docker

    # Used to be `run_test ... test_command docker || docker compose version`, which
    # tested docker twice and never checked compose at all.
    if [[ " ubuntu arch " == *" $PLATFORM "* ]]; then
        if command -v docker-compose >/dev/null 2>&1 ||
            docker compose version >/dev/null 2>&1; then
            record PASS "docker compose (plugin or standalone)"
        else
            record FAIL "docker compose not available"
        fi
    else
        record SKIP "docker compose (not provided by the $PLATFORM installer)"
    fi

    # Group membership is only picked up by a *new* login session. In a container there
    # is no login at all, so this can never pass there however correct the installer is -
    # it is unverifiable rather than failing, hence SKIP instead of FAIL.
    if ! command -v docker >/dev/null 2>&1; then
        record SKIP "docker group membership (docker not installed)"
    elif id -nG 2>/dev/null | tr ' ' '\n' | grep -qx docker; then
        record PASS "User in docker group"
    else
        record SKIP "docker group membership (needs logout/login to take effect)"
    fi
}

################################################################################
# DEVOPS TOOLS TESTS
################################################################################

test_devops_tools() {
    log_section "DevOps Tools"

    # HashiCorp's apt repository is Ubuntu-only here; neither the Arch nor the Amazon
    # Linux installer attempts terraform or packer.
    expect_on "ubuntu" "terraform" test_command terraform
    expect_on "ubuntu" "packer" test_command packer
}

################################################################################
# CARGO PACKAGES TESTS
################################################################################

test_cargo_packages() {
    log_section "Cargo Packages"

    # Ubuntu builds it with `cargo install yazi-build`, Arch installs the pacman package.
    expect_on "ubuntu arch" "yazi" test_command yazi
}

################################################################################
# AI TOOLS TESTS
################################################################################

test_ai_tools() {
    log_section "AI Tools"

    expect_on "ubuntu arch amzn" "agent-deck" test_command agent-deck
    show_version agent-deck

    expect_on "ubuntu arch amzn" "vibe-kanban" test_command vibe-kanban
}

################################################################################
# MAIN
################################################################################

main() {
    log_section "Installation Verification Test Suite"
    echo ""
    echo "Running comprehensive installation tests..."
    echo "Platform: $PLATFORM"
    echo "Use --verbose flag for version information"
    echo ""

    if [ "$PLATFORM" = "unknown" ]; then
        log_warn "Unrecognised platform - every platform-scoped test will be skipped."
    fi
    if [ "$PLATFORM" = "termux" ]; then
        log_warn "Termux: install-termux.sh provisions no tools and never runs init.sh,"
        log_warn "so almost everything here is out of scope. See make/test/README.md."
    fi

    load_environment

    # Run all test groups
    test_system_tools
    test_programming_languages
    test_nodejs
    test_shell_tools
    test_editors
    test_tmux
    test_git_tools
    test_python_tools
    test_container_tools
    test_devops_tools
    test_cargo_packages
    test_ai_tools

    # Print summary
    log_section "Test Summary"
    echo ""
    echo -e "${LOG_GREEN}Passed:${LOG_NC}  $TESTS_PASSED"
    echo -e "${LOG_RED}Failed:${LOG_NC}  $TESTS_FAILED"
    echo -e "${LOG_CYAN}Skipped:${LOG_NC} $TESTS_SKIPPED  (out of scope for $PLATFORM)"
    echo ""

    local total=$((TESTS_PASSED + TESTS_FAILED))
    if [[ $TESTS_FAILED -eq 0 ]]; then
        log_success "All $total applicable tests passed!"
        return 0
    else
        log_error "$TESTS_FAILED out of $total applicable tests failed"
        return 1
    fi
}

# Run main
main "$@"
