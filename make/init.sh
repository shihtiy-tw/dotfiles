#!/bin/bash
################################################################################
# Dotfiles Initialization Script
#
# Description: Creates symlinks for all dotfiles configurations
# Author: shihtiy-tw
# Last Updated: 2026-02-01
################################################################################

set -u
set -o pipefail

################################################################################
# SETUP - Source Shared Modules
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source shared logger
source "$SCRIPT_DIR/modules/helpers/logger.sh"

################################################################################
# HELPER FUNCTIONS
################################################################################

# Function to create symlink with backup
link_config() {
    local source="$1"
    local target="$2"
    local dir
    dir="$(dirname "$target")"

    # Create parent directory if needed
    if [ ! -d "$dir" ]; then
        log_info "Creating directory: $dir"
        mkdir -p "$dir"
    fi

    # Check if target already exists
    if [ -e "$target" ] || [ -L "$target" ]; then
        # Normalize paths for comparison
        local real_source
        local real_target
        real_source="$(readlink -f "$source")"
        real_target="$(readlink -f "$target")"

        # Check if it's already a correct symlink
        if [ "$real_source" = "$real_target" ]; then
            log_skip "Link exists: $target -> $source"
            return 0
        fi

        # Backup existing file/directory
        # Use timestamp to avoid overwriting existing backups
        local backup_path="$target.backup.$(date +%s)"
        log_warn "Backing up: $target -> $backup_path"
        mv "$target" "$backup_path"
    fi

    # Ensure target is gone (redundant safety check)
    rm -rf "$target"

    # Create symlink
    # Use -n (no-dereference) if available to avoid linking inside a directory
    ln -sfn "$source" "$target" 2>/dev/null || ln -sf "$source" "$target"
    log_success "Linked: $target -> $source"
}

################################################################################
# MAIN CONFIGURATION
################################################################################

log_section "Initializing Dotfiles"

# Define base directory
DOTFILES="$HOME/dotfiles"

# Zsh
link_config "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
# link_config "$DOTFILES/zsh/ieni.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/ieni.zsh-theme"

# Bash (Commented out in original, keeping as is but ready)
# link_config "$DOTFILES/bashrc" "$HOME/.bashrc"
# link_config "$DOTFILES/bashrc" "$HOME/.bash_profile"

# Git
link_config "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"

# Tmux
link_config "$DOTFILES/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
link_config "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

# Vim
link_config "$DOTFILES/vim/vimrc" "$HOME/.vimrc"
link_config "$DOTFILES/vim/editorconfig" "$HOME/.editorconfig"

# Neovim
link_config "$DOTFILES/nvim/init.lua" "$HOME/.config/nvim/init.lua"
link_config "$DOTFILES/nvim/lua" "$HOME/.config/nvim/lua"
# coc-settings.json is not linked: the neovim config uses native LSP + blink.cmp,
# and the file itself belongs to the legacy nvim/vimscript setup.

# AWS
link_config "$DOTFILES/aws/config" "$HOME/.aws/config"

# Kitty
link_config "$DOTFILES/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# Ghostty
link_config "$DOTFILES/ghostty/ghostty.conf" "$HOME/.config/ghostty/config"

# Alacritty (New addition)
link_config "$DOTFILES/alacritty/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"

# Opencode
link_config "$DOTFILES/opencode/opencode.jsonc" "$HOME/.config/opencode/opencode.jsonc"

# Oh-My-Zsh Theme
if [ -d "$HOME/.oh-my-zsh/custom/themes" ]; then
    SPACESHIP_THEME="$HOME/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme"
    if [ -f "$SPACESHIP_THEME" ]; then
        link_config "$SPACESHIP_THEME" "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
    fi
fi

################################################################################
# COMPLETION
################################################################################

echo ""
log_success "Dotfiles initialization complete!"
log_info "Run 'make test' to verify your configuration."
echo ""
