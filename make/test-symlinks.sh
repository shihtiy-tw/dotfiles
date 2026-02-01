#!/bin/bash
################################################################################
# Test Script - Verify All Symlinks
#
# This script verifies that all dotfile symlinks have been created correctly
# by the init.sh script. It checks:
#   - Symlink exists
#   - Symlink points to correct target
#   - Target file exists
#
# Usage: ./test-symlinks.sh [--fix]
#
# Options:
#   --fix   Attempt to fix broken symlinks
#
# Exit codes:
#   0 - All symlinks valid
#   1 - Some symlinks broken or missing
################################################################################

set -u  # Exit on undefined variable

################################################################################
# SETUP
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Source logger
source "$SCRIPT_DIR/modules/helpers/logger.sh"

# Counters
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_FIXED=0

# Parse arguments
FIX_MODE=false
if [[ "${1:-}" == "--fix" ]]; then
    FIX_MODE=true
fi

################################################################################
# SYMLINK DEFINITIONS
# Format: "symlink_path:target_path"
################################################################################

SYMLINKS=(
    # Shell configs
    "$HOME/.zshrc:$DOTFILES_DIR/zsh/zshrc"
    
    # Git configs  
    "$HOME/.gitconfig:$DOTFILES_DIR/git/gitconfig"
    
    # Vim/Neovim configs
    "$HOME/.vimrc:$DOTFILES_DIR/vim/vimrc"
    "$HOME/.editorconfig:$DOTFILES_DIR/vim/editorconfig"
    "$HOME/.config/nvim/init.lua:$DOTFILES_DIR/nvim/init.lua"
    "$HOME/.config/nvim/lua:$DOTFILES_DIR/nvim/lua"
    "$HOME/.config/nvim/coc-settings.json:$DOTFILES_DIR/nvim/coc-settings.json"
    
    # Tmux config
    "$HOME/.config/tmux/tmux.conf:$DOTFILES_DIR/tmux/tmux.conf"
    "$HOME/.tmux.conf:$DOTFILES_DIR/tmux/tmux.conf"
    
    # AWS config
    "$HOME/.aws/config:$DOTFILES_DIR/aws/config"
    
    # Kitty terminal
    "$HOME/.config/kitty/kitty.conf:$DOTFILES_DIR/kitty/kitty.conf"
    
    # Ghostty terminal
    "$HOME/.config/ghostty/config:$DOTFILES_DIR/ghostty/ghostty.conf"
    
    # Opencode
    "$HOME/.config/opencode/opencode.jsonc:$DOTFILES_DIR/opencode/opencode.jsonc"
    
    # Oh-My-Zsh theme symlink
    "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme:$HOME/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme"
)

################################################################################
# TEST HELPERS
################################################################################

# Check if path is a valid symlink pointing to expected target
# Returns: 0 if valid, 1 if missing, 2 if broken, 3 if wrong target
check_symlink() {
    local symlink_path="$1"
    local expected_target="$2"
    
    # Check if symlink exists
    if [[ ! -L "$symlink_path" ]]; then
        if [[ -e "$symlink_path" ]]; then
            return 4  # Regular file exists instead of symlink
        fi
        return 1  # Missing
    fi
    
    # Get actual target
    local actual_target
    actual_target=$(readlink "$symlink_path")
    
    # Resolve relative paths
    if [[ ! "$actual_target" = /* ]]; then
        actual_target="$(dirname "$symlink_path")/$actual_target"
    fi
    actual_target=$(cd "$(dirname "$actual_target")" 2>/dev/null && pwd)/$(basename "$actual_target") 2>/dev/null || echo "$actual_target"
    expected_target=$(cd "$(dirname "$expected_target")" 2>/dev/null && pwd)/$(basename "$expected_target") 2>/dev/null || echo "$expected_target"
    
    # Check if target exists
    if [[ ! -e "$symlink_path" ]]; then
        return 2  # Broken symlink (target doesn't exist)
    fi
    
    # Check if target matches (normalize paths)
    local norm_actual norm_expected
    norm_actual=$(readlink -f "$symlink_path" 2>/dev/null || echo "$actual_target")
    norm_expected=$(readlink -f "$expected_target" 2>/dev/null || echo "$expected_target")
    
    if [[ "$norm_actual" != "$norm_expected" ]]; then
        return 3  # Wrong target
    fi
    
    return 0  # Valid
}

# Fix a symlink
fix_symlink() {
    local symlink_path="$1"
    local target="$2"
    
    # Create parent directory if needed
    local parent_dir
    parent_dir=$(dirname "$symlink_path")
    if [[ ! -d "$parent_dir" ]]; then
        mkdir -p "$parent_dir"
        log_info "Created directory: $parent_dir"
    fi
    
    # Remove existing file/symlink if present
    if [[ -e "$symlink_path" ]] || [[ -L "$symlink_path" ]]; then
        rm -rf "$symlink_path"
    fi
    
    # Create symlink
    if ln -sf "$target" "$symlink_path"; then
        log_success "Fixed: $symlink_path -> $target"
        ((TESTS_FIXED++))
        return 0
    else
        log_error "Failed to fix: $symlink_path"
        return 1
    fi
}

# Test a single symlink
test_symlink() {
    local symlink_path="$1"
    local target="$2"
    local display_path="${symlink_path/#$HOME/~}"
    local display_target="${target/#$HOME/~}"
    display_target="${display_target/#$DOTFILES_DIR/\$DOTFILES}"
    
    check_symlink "$symlink_path" "$target"
    local result=$?
    
    case $result in
        0)
            log_test "PASS" "$display_path -> $display_target"
            ((TESTS_PASSED++))
            return 0
            ;;
        1)
            log_test "FAIL" "$display_path (missing)"
            if $FIX_MODE; then
                if [[ -e "$target" ]]; then
                    fix_symlink "$symlink_path" "$target"
                else
                    log_warn "Cannot fix: target does not exist: $display_target"
                fi
            fi
            ((TESTS_FAILED++))
            return 1
            ;;
        2)
            log_test "FAIL" "$display_path (broken - target missing)"
            if $FIX_MODE; then
                log_warn "Cannot fix: target does not exist: $display_target"
            fi
            ((TESTS_FAILED++))
            return 1
            ;;
        3)
            log_test "FAIL" "$display_path (wrong target)"
            if $FIX_MODE; then
                fix_symlink "$symlink_path" "$target"
            fi
            ((TESTS_FAILED++))
            return 1
            ;;
        4)
            log_test "FAIL" "$display_path (regular file exists instead of symlink)"
            if $FIX_MODE; then
                log_warn "Backing up existing file..."
                mv "$symlink_path" "${symlink_path}.backup.$(date +%s)"
                fix_symlink "$symlink_path" "$target"
            fi
            ((TESTS_FAILED++))
            return 1
            ;;
    esac
}

################################################################################
# MAIN
################################################################################

main() {
    log_section "Symlink Verification Test Suite"
    echo ""
    echo "Checking dotfile symlinks..."
    echo "DOTFILES_DIR: $DOTFILES_DIR"
    if $FIX_MODE; then
        echo -e "${LOG_YELLOW}FIX MODE: Will attempt to repair broken symlinks${LOG_NC}"
    fi
    echo ""
    
    log_section "Shell Configuration"
    for entry in "${SYMLINKS[@]}"; do
        # Parse entry
        local symlink_path="${entry%%:*}"
        local target="${entry#*:}"
        
        # Group by category based on path
        case "$symlink_path" in
            */.zshrc|*/.bashrc)
                # Shell configs - already in section
                ;;
            *)
                # Continue with test
                ;;
        esac
        
        test_symlink "$symlink_path" "$target"
    done
    
    # Print summary
    log_section "Test Summary"
    echo ""
    echo -e "${LOG_GREEN}Valid:${LOG_NC}   $TESTS_PASSED"
    echo -e "${LOG_RED}Invalid:${LOG_NC} $TESTS_FAILED"
    if $FIX_MODE && [[ $TESTS_FIXED -gt 0 ]]; then
        echo -e "${LOG_YELLOW}Fixed:${LOG_NC}   $TESTS_FIXED"
    fi
    echo ""
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        log_success "All symlinks are valid!"
        return 0
    else
        if $FIX_MODE; then
            if [[ $TESTS_FAILED -eq $TESTS_FIXED ]]; then
                log_success "All broken symlinks have been fixed!"
                return 0
            else
                log_warn "Some symlinks could not be fixed (missing targets)"
                return 1
            fi
        else
            log_error "$TESTS_FAILED symlinks are broken or missing"
            log_info "Run with --fix flag to attempt repairs"
            return 1
        fi
    fi
}

# Run main
main "$@"
