#!/bin/bash
################################################################################
# Combined Test Runner - Run All Verification Tests
#
# This script runs all test scripts to verify your dotfiles installation.
#
# Usage: ./test.sh [options]
#
# Options:
#   --install   Run only installation tests
#   --symlinks  Run only symlink tests
#   --fix       Fix broken symlinks (with --symlinks)
#   --verbose   Show verbose output
#   --help      Show this help
#
# Exit codes:
#   0 - All tests passed
#   1 - Some tests failed
################################################################################

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source logger
source "$SCRIPT_DIR/modules/helpers/logger.sh"

################################################################################
# HELP
################################################################################

show_help() {
    cat << EOF
Dotfiles Test Suite

Usage: $0 [options]

Options:
    --install   Run only installation verification tests
    --symlinks  Run only symlink verification tests  
    --fix       Fix broken symlinks (use with --symlinks or alone)
    --verbose   Show verbose output (version info, etc.)
    --help      Show this help message

Examples:
    $0                  # Run all tests
    $0 --install        # Run only installation tests
    $0 --symlinks --fix # Run symlink tests and fix any issues
    $0 --verbose        # Run all tests with verbose output

EOF
}

################################################################################
# MAIN
################################################################################

main() {
    local run_install=true
    local run_symlinks=true
    local fix_symlinks=false
    local verbose=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --install)
                run_install=true
                run_symlinks=false
                ;;
            --symlinks)
                run_install=false
                run_symlinks=true
                ;;
            --fix)
                fix_symlinks=true
                ;;
            --verbose|-v)
                verbose=true
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done
    
    log_section "Dotfiles Test Suite"
    echo ""
    echo "Running verification tests..."
    echo ""
    
    local overall_result=0
    
    # Run installation tests
    if $run_install; then
        echo ""
        log_info "Running installation tests..."
        echo ""
        
        local install_args=""
        if $verbose; then
            install_args="--verbose"
        fi
        
        if "$SCRIPT_DIR/test-install.sh" $install_args; then
            log_success "Installation tests passed"
        else
            log_error "Installation tests failed"
            overall_result=1
        fi
    fi
    
    # Run symlink tests
    if $run_symlinks; then
        echo ""
        log_info "Running symlink tests..."
        echo ""
        
        local symlink_args=""
        if $fix_symlinks; then
            symlink_args="--fix"
        fi
        
        if "$SCRIPT_DIR/test-symlinks.sh" $symlink_args; then
            log_success "Symlink tests passed"
        else
            log_error "Symlink tests failed"
            overall_result=1
        fi
    fi
    
    # Final summary
    echo ""
    log_section "Overall Result"
    
    if [[ $overall_result -eq 0 ]]; then
        log_success "All tests passed!"
    else
        log_error "Some tests failed. Review output above for details."
    fi
    
    return $overall_result
}

main "$@"
