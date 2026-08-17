#!/usr/bin/env bash
#
# Undo what init.sh linked: remove symlinks that point into this repo, and restore
# the timestamped backup init.sh left behind (init.sh:55-57 writes
# "<target>.backup.<epoch>").
#
# This deliberately discovers state rather than hardcoding a list of targets. The
# `remove_env` Makefile target used to carry its own copy of the link list with a
# third, incompatible backup suffix (plain ".backup"), so it could never restore
# what init.sh actually wrote. Deriving from the filesystem means this cannot drift
# out of sync with init.sh the way test-symlinks.sh's table has.
#
# Safety properties, deliberately narrow:
#   - only ever removes a path that IS a symlink AND resolves inside $DOTFILES
#   - never uses `rm -r`; a symlink to a directory is removed with plain `rm`
#   - restores only from "<path>.backup.<digits>", newest wins
#   - refuses to run with an empty $HOME

set -u
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/modules/helpers/logger.sh"

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

if [[ -z "${HOME:-}" ]]; then
    log_error "HOME is empty; refusing to run"
    exit 1
fi

# Bounded search roots. init.sh only ever links into $HOME itself, $HOME/.config,
# $HOME/.aws, and the oh-my-zsh custom themes dir, so there is no reason to walk
# all of $HOME.
declare -a SEARCH=(
    "$HOME:1"
    "$HOME/.config:3"
    "$HOME/.aws:1"
    "$HOME/.oh-my-zsh/custom/themes:1"
)

removed=0
restored=0
skipped=0

restore_backup() {
    local target="$1"
    # Newest "<target>.backup.<epoch>" by numeric suffix.
    local newest=""
    local candidate
    for candidate in "$target".backup.*; do
        [[ -e "$candidate" || -L "$candidate" ]] || continue
        [[ "$candidate" =~ \.backup\.[0-9]+$ ]] || continue
        if [[ -z "$newest" || "${candidate##*.}" -gt "${newest##*.}" ]]; then
            newest="$candidate"
        fi
    done

    if [[ -z "$newest" ]]; then
        log_info "no backup to restore for $target"
        return 0
    fi

    if $DRY_RUN; then
        log_info "[dry-run] would restore $newest -> $target"
    else
        if mv -- "$newest" "$target"; then
            log_success "restored $target from $(basename "$newest")"
            ((restored++)) || true
        else
            log_error "failed to restore $newest -> $target"
            return 1
        fi
    fi
}

process_root() {
    local root="${1%%:*}"
    local depth="${1##*:}"
    [[ -d "$root" ]] || return 0

    local link resolved
    while IFS= read -r link; do
        [[ -n "$link" ]] || continue
        resolved="$(readlink -f -- "$link" 2>/dev/null || true)"

        # Only touch links that point back into this repo. Anything else belongs
        # to the user or another tool.
        if [[ "$resolved" != "$DOTFILES"/* ]]; then
            ((skipped++)) || true
            continue
        fi

        if $DRY_RUN; then
            log_info "[dry-run] would unlink $link -> $resolved"
        else
            # Plain rm: this is always a symlink, never a real directory.
            if rm -- "$link"; then
                log_success "unlinked $link"
                ((removed++)) || true
            else
                log_error "failed to unlink $link"
                continue
            fi
        fi

        restore_backup "$link"
    done < <(find "$root" -maxdepth "$depth" -type l 2>/dev/null)
}

log_section "Removing dotfiles symlinks"
log_info "repo: $DOTFILES"
$DRY_RUN && log_warn "dry-run: nothing will be changed"

for entry in "${SEARCH[@]}"; do
    process_root "$entry"
done

log_section "Summary"
log_info "unlinked:  $removed"
log_info "restored:  $restored"
log_info "untouched: $skipped (symlinks not pointing into $DOTFILES)"

exit 0
