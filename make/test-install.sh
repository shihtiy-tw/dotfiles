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
# TEST HELPERS
################################################################################

# Run a test and record result
# Usage: run_test "description" test_command args...
run_test() {
    local description="$1"
    shift
    
    if "$@"; then
        log_test "PASS" "$description"
        ((TESTS_PASSED++))
        return 0
    else
        log_test "FAIL" "$description"
        ((TESTS_FAILED++))
        return 1
    fi
}

# Check if a command exists
test_command() {
    local cmd="$1"
    command -v "$cmd" >/dev/null 2>&1
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
    run_test "wget" test_command wget
    run_test "tree" test_command tree
    run_test "htop" test_command htop
    run_test "tmux" test_command tmux
    show_version tmux
    
    run_test "ripgrep (rg)" test_command rg
    run_test "silversearcher (ag)" test_command ag
    run_test "fzf" test_command fzf
    run_test "tig" test_command tig
    run_test "shellcheck" test_command shellcheck
}

################################################################################
# PROGRAMMING LANGUAGES TESTS
################################################################################

test_programming_languages() {
    log_section "Programming Languages"
    
    # Python
    run_test "python3" test_command python3
    show_version python3
    run_test "pip3" test_command pip3
    
    # Rust
    run_test "rustc (Rust compiler)" test_command rustc
    show_version rustc
    run_test "cargo" test_command cargo
    show_version cargo
    run_test "rustup" test_command rustup
    
    # Go
    run_test "go" test_command go
    show_version go
    
    # Java
    run_test "java" test_command java
    run_test "javac" test_command javac
    
    # Ruby
    run_test "ruby" test_command ruby
    show_version ruby
    run_test "gem" test_command gem
    
    # Bun
    run_test "bun" test_command bun
    show_version bun
    
    # Lua
    run_test "lua" test_command lua || run_test "luarocks" test_command luarocks
}

################################################################################
# NODE.JS TESTS
################################################################################

test_nodejs() {
    log_section "Node.js / NVM"
    
    # Check NVM directory
    run_test "NVM directory" test_directory "${NVM_DIR:-$HOME/.nvm}"
    
    # Load NVM if available
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
        # shellcheck source=/dev/null
        \. "$NVM_DIR/nvm.sh"
    fi
    
    run_test "nvm command" test_command nvm
    run_test "node" test_command node
    show_version node
    run_test "npm" test_command npm
    show_version npm
}

################################################################################
# SHELL TOOLS TESTS
################################################################################

test_shell_tools() {
    log_section "Shell Tools"
    
    run_test "zsh" test_command zsh
    show_version zsh
    
    # Oh-My-Zsh
    run_test "Oh-My-Zsh directory" test_directory "$HOME/.oh-my-zsh"
    run_test "Oh-My-Zsh: zsh-autosuggestions" test_directory "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    run_test "Oh-My-Zsh: zsh-syntax-highlighting" test_directory "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    run_test "Oh-My-Zsh: zsh-completions" test_directory "$HOME/.oh-my-zsh/custom/plugins/zsh-completions"
    run_test "Oh-My-Zsh: zsh-vim-mode" test_directory "$HOME/.oh-my-zsh/custom/plugins/zsh-vim-mode"
    run_test "Oh-My-Zsh: fzf-tab" test_directory "$HOME/.oh-my-zsh/custom/plugins/fzf-tab"
    run_test "Oh-My-Zsh: zsh-system-clipboard" test_directory "$HOME/.oh-my-zsh/custom/plugins/zsh-system-clipboard"
    run_test "Oh-My-Zsh: spaceship-prompt theme" test_directory "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt"
    
    # Autojump
    run_test "autojump directory" test_directory "$HOME/.autojump"
    run_test "autojump binary" test_file "$HOME/.autojump/bin/autojump"
    
    # FZF
    run_test "fzf directory" test_directory "$HOME/.fzf"
}

################################################################################
# EDITOR TESTS
################################################################################

test_editors() {
    log_section "Editors"
    
    run_test "neovim (nvim)" test_command nvim
    show_version nvim
    
    run_test "vim" test_command vim
}

################################################################################
# TMUX TESTS
################################################################################

test_tmux() {
    log_section "Tmux"
    
    run_test "tmux" test_command tmux
    run_test "Tmux Plugin Manager (TPM)" test_directory "$HOME/.tmux/plugins/tpm"
}

################################################################################
# GIT TOOLS TESTS
################################################################################

test_git_tools() {
    log_section "Git Tools"
    
    run_test "git" test_command git
    run_test "git-flow" test_command git-flow
    run_test "git-lfs" test_command git-lfs
    run_test "diff-so-fancy" test_command diff-so-fancy
    run_test "gh (GitHub CLI)" test_command gh
    
    # Git config checks
    if git config --global commit.template >/dev/null 2>&1; then
        log_test "PASS" "Git commit template configured"
        ((TESTS_PASSED++))
    else
        log_test "FAIL" "Git commit template not configured"
        ((TESTS_FAILED++))
    fi
}

################################################################################
# PYTHON VERSION MANAGER TESTS
################################################################################

test_python_tools() {
    log_section "Python Version Manager"
    
    run_test "pyenv directory" test_directory "$HOME/.pyenv"
    run_test "pyenv binary" test_file "$HOME/.pyenv/bin/pyenv"
    
    run_test "pipx" test_command pipx
}

################################################################################
# CONTAINER TOOLS TESTS
################################################################################

test_container_tools() {
    log_section "Container Tools"
    
    run_test "docker" test_command docker
    show_version docker
    
    run_test "docker-compose / docker compose" test_command docker || docker compose version >/dev/null 2>&1
    
    # Check if user is in docker group
    if groups | grep -q docker; then
        log_test "PASS" "User in docker group"
        ((TESTS_PASSED++))
    else
        log_test "FAIL" "User not in docker group (may need logout/login)"
        ((TESTS_FAILED++))
    fi
}

################################################################################
# DEVOPS TOOLS TESTS
################################################################################

test_devops_tools() {
    log_section "DevOps Tools"
    
    run_test "terraform" test_command terraform
    run_test "packer" test_command packer
}

################################################################################
# CARGO PACKAGES TESTS
################################################################################

test_cargo_packages() {
    log_section "Cargo Packages"
    
    # Source cargo if available
    if [[ -f "$HOME/.cargo/env" ]]; then
        # shellcheck source=/dev/null
        source "$HOME/.cargo/env"
    fi
    
    run_test "yazi" test_command yazi
}

################################################################################
# MAIN
################################################################################

main() {
    log_section "Installation Verification Test Suite"
    echo ""
    echo "Running comprehensive installation tests..."
    echo "Use --verbose flag for version information"
    echo ""
    
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
    
    # Print summary
    log_section "Test Summary"
    echo ""
    echo -e "${LOG_GREEN}Passed:${LOG_NC}  $TESTS_PASSED"
    echo -e "${LOG_RED}Failed:${LOG_NC}  $TESTS_FAILED"
    echo -e "${LOG_CYAN}Skipped:${LOG_NC} $TESTS_SKIPPED"
    echo ""
    
    local total=$((TESTS_PASSED + TESTS_FAILED))
    if [[ $TESTS_FAILED -eq 0 ]]; then
        log_success "All $total tests passed!"
        return 0
    else
        log_error "$TESTS_FAILED out of $total tests failed"
        return 1
    fi
}

# Run main
main "$@"
