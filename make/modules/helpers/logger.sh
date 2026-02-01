#!/bin/bash
################################################################################
# Logger Module - Shared logging utilities for all installation scripts
# 
# Usage: source this file at the beginning of your installation script
#   source "$(dirname "$0")/modules/helpers/logger.sh"
#
# Functions:
#   log_info    - Blue informational messages
#   log_success - Green success messages
#   log_error   - Red error messages (non-fatal)
#   log_warn    - Yellow warning messages
#   log_skip    - Cyan skip messages (already installed)
#   log_section - Magenta section headers
#   safe_exec   - Execute command with logging and error handling
################################################################################

# Prevent multiple sourcing
if [[ -n "${_LOGGER_LOADED:-}" ]]; then
    return 0
fi
readonly _LOGGER_LOADED=1

################################################################################
# COLOR CODES
################################################################################

# Check if output supports colors
if [[ -t 1 ]] && [[ -n "${TERM:-}" ]] && [[ "${TERM}" != "dumb" ]]; then
    readonly LOG_RED='\033[0;31m'
    readonly LOG_GREEN='\033[0;32m'
    readonly LOG_YELLOW='\033[1;33m'
    readonly LOG_BLUE='\033[0;34m'
    readonly LOG_MAGENTA='\033[0;35m'
    readonly LOG_CYAN='\033[0;36m'
    readonly LOG_NC='\033[0m'
    readonly LOG_BOLD='\033[1m'
else
    readonly LOG_RED=''
    readonly LOG_GREEN=''
    readonly LOG_YELLOW=''
    readonly LOG_BLUE=''
    readonly LOG_MAGENTA=''
    readonly LOG_CYAN=''
    readonly LOG_NC=''
    readonly LOG_BOLD=''
fi

################################################################################
# LOGGING FUNCTIONS
################################################################################

# Get current timestamp for logging
_log_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Log info message (blue)
log_info() {
    echo -e "${LOG_BLUE}[INFO]${LOG_NC} $(_log_timestamp) - $*"
}

# Log success message (green)
log_success() {
    echo -e "${LOG_GREEN}[SUCCESS]${LOG_NC} $(_log_timestamp) - $*"
}

# Log error message (red) - outputs to stderr but doesn't exit
log_error() {
    echo -e "${LOG_RED}[ERROR]${LOG_NC} $(_log_timestamp) - $*" >&2
}

# Log warning message (yellow)
log_warn() {
    echo -e "${LOG_YELLOW}[WARN]${LOG_NC} $(_log_timestamp) - $*"
}

# Log skip message (cyan) - used when something is already installed
log_skip() {
    echo -e "${LOG_CYAN}[SKIP]${LOG_NC} $(_log_timestamp) - $*"
}

# Log section header (magenta/bold)
log_section() {
    echo ""
    echo -e "${LOG_BOLD}${LOG_MAGENTA}════════════════════════════════════════════════════════════${LOG_NC}"
    echo -e "${LOG_BOLD}${LOG_MAGENTA}  $*${LOG_NC}"
    echo -e "${LOG_BOLD}${LOG_MAGENTA}════════════════════════════════════════════════════════════${LOG_NC}"
    echo ""
}

# Log test result for verification scripts
log_test() {
    local status="$1"
    local message="$2"
    
    if [[ "$status" == "PASS" ]]; then
        echo -e "${LOG_GREEN}[PASS]${LOG_NC} $message"
    else
        echo -e "${LOG_RED}[FAIL]${LOG_NC} $message"
    fi
}

################################################################################
# EXECUTION HELPERS
################################################################################

# Execute command with logging and error handling
# Usage: safe_exec "description" command args...
# Returns: 0 on success, non-zero on failure (but doesn't exit)
safe_exec() {
    local description="$1"
    shift
    
    log_info "Starting: $description"
    
    if "$@"; then
        log_success "Completed: $description"
        return 0
    else
        local exit_code=$?
        log_error "Failed: $description (exit code: $exit_code)"
        log_warn "Continuing with installation despite error..."
        return $exit_code
    fi
}

# Execute command silently, only log on error
# Usage: quiet_exec "description" command args...
quiet_exec() {
    local description="$1"
    shift
    
    if "$@" >/dev/null 2>&1; then
        return 0
    else
        local exit_code=$?
        log_error "Failed: $description (exit code: $exit_code)"
        return $exit_code
    fi
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a directory exists
dir_exists() {
    [[ -d "$1" ]]
}

# Check if a file exists
file_exists() {
    [[ -f "$1" ]]
}

# Check if a symlink exists
symlink_exists() {
    [[ -L "$1" ]]
}

################################################################################
# EXPORT FUNCTIONS FOR SUBSHELLS
################################################################################

export -f log_info log_success log_error log_warn log_skip log_section log_test
export -f safe_exec quiet_exec command_exists dir_exists file_exists symlink_exists
export -f _log_timestamp
