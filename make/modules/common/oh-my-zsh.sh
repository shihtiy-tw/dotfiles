#!/bin/bash
################################################################################
# Oh-My-Zsh Module - Install and configure Oh-My-Zsh with plugins and themes
#
# Usage: source this file and call install_oh_my_zsh
#   source "$(dirname "$0")/modules/common/oh-my-zsh.sh"
#   install_oh_my_zsh
#
# Installs:
#   - Oh-My-Zsh framework
#   - zsh-autosuggestions plugin
#   - zsh-syntax-highlighting plugin
#   - zsh-completions plugin
#   - zsh-vim-mode plugin
#   - fzf-tab plugin
#   - zsh-system-clipboard plugin
#   - spaceship-prompt theme
#   - spaceship-vi-mode plugin
################################################################################

# Prevent multiple sourcing
if [[ -n "${_OMZ_MODULE_LOADED:-}" ]]; then
    return 0
fi
readonly _OMZ_MODULE_LOADED=1

# Source logger if not already loaded
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${_LOGGER_LOADED:-}" ]]; then
    source "$MODULE_DIR/../helpers/logger.sh"
fi

################################################################################
# CONFIGURATION
################################################################################

readonly OMZ_DIR="$HOME/.oh-my-zsh"
readonly OMZ_CUSTOM="$OMZ_DIR/custom"
readonly OMZ_PLUGINS_DIR="$OMZ_CUSTOM/plugins"
readonly OMZ_THEMES_DIR="$OMZ_CUSTOM/themes"

# Plugin repositories
declare -A OMZ_PLUGINS=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
    ["zsh-vim-mode"]="https://github.com/softmoth/zsh-vim-mode.git"
    ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab"
    ["zsh-system-clipboard"]="https://github.com/kutsan/zsh-system-clipboard"
    ["spaceship-vi-mode"]="https://github.com/spaceship-prompt/spaceship-vi-mode.git"
)

################################################################################
# FUNCTIONS
################################################################################

# Install Oh-My-Zsh framework
_install_omz_framework() {
    if dir_exists "$OMZ_DIR"; then
        log_skip "Oh-My-Zsh already installed"
        return 0
    fi

    log_info "Installing Oh-My-Zsh framework..."
    if git clone https://github.com/robbyrussell/oh-my-zsh.git "$OMZ_DIR"; then
        log_success "Oh-My-Zsh framework installed"
        return 0
    else
        log_error "Failed to install Oh-My-Zsh framework"
        return 1
    fi
}

# Install a single Oh-My-Zsh plugin
# Usage: _install_omz_plugin "plugin-name" "git-url"
_install_omz_plugin() {
    local plugin_name="$1"
    local plugin_url="$2"
    local plugin_dir="$OMZ_PLUGINS_DIR/$plugin_name"

    if dir_exists "$plugin_dir"; then
        log_skip "Plugin $plugin_name already installed"
        return 0
    fi

    log_info "Installing Oh-My-Zsh plugin: $plugin_name"
    if git clone "$plugin_url" "$plugin_dir"; then
        log_success "Plugin $plugin_name installed"
        return 0
    else
        log_error "Failed to install plugin: $plugin_name"
        return 1
    fi
}

# Install all Oh-My-Zsh plugins
_install_omz_plugins() {
    log_info "Installing Oh-My-Zsh plugins..."

    for plugin_name in "${!OMZ_PLUGINS[@]}"; do
        _install_omz_plugin "$plugin_name" "${OMZ_PLUGINS[$plugin_name]}"
    done
}

# Install and configure Spaceship prompt theme
_install_spaceship_theme() {
    local theme_dir="$OMZ_THEMES_DIR/spaceship-prompt"

    if dir_exists "$theme_dir"; then
        log_skip "Spaceship theme already installed"
        return 0
    fi

    log_info "Installing Spaceship prompt theme..."

    if ! git clone https://github.com/denysdovhan/spaceship-prompt.git "$theme_dir"; then
        log_error "Failed to install Spaceship theme"
        return 1
    fi

    # Configure Spaceship prompt symbol
    local char_file="$theme_dir/sections/char.zsh"
    if file_exists "$char_file"; then
        # Use different sed syntax for macOS vs Linux
        if [[ "$(uname)" == "Darwin" ]]; then
            sed -i '' 's/^SPACESHIP_CHAR_SYMBOL=.*$/SPACESHIP_CHAR_SYMBOL="${SPACESHIP_CHAR_SYMBOL="$ "}"/' "$char_file"
        else
            sed -i 's/^SPACESHIP_CHAR_SYMBOL=.*$/SPACESHIP_CHAR_SYMBOL="${SPACESHIP_CHAR_SYMBOL="$ "}"/' "$char_file"
        fi
    fi

    # Configure VI mode (disable by default)
    local vi_mode_file="$theme_dir/sections/vi_mode.zsh"
    if file_exists "$vi_mode_file"; then
        if [[ "$(uname)" == "Darwin" ]]; then
            sed -i '' 's/^SPACESHIP_VI_MODE_SHOW=.*$/SPACESHIP_VI_MODE_SHOW="${SPACESHIP_VI_MODE_SHOW=false}"/' "$vi_mode_file"
        else
            sed -i 's/^SPACESHIP_VI_MODE_SHOW=.*$/SPACESHIP_VI_MODE_SHOW="${SPACESHIP_VI_MODE_SHOW=false}"/' "$vi_mode_file"
        fi
    fi

    # Create symlink for theme
    ln -sf "$theme_dir/spaceship.zsh-theme" "$OMZ_THEMES_DIR/spaceship.zsh-theme" 2>/dev/null || true

    log_success "Spaceship theme installed and configured"
    return 0
}

# Main installation function
install_oh_my_zsh() {
    log_section "Installing Oh-My-Zsh"

    _install_omz_framework
    _install_omz_plugins
    _install_spaceship_theme

    log_success "Oh-My-Zsh installation complete"
}

# Verify Oh-My-Zsh installation
verify_oh_my_zsh() {
    local all_pass=true

    log_section "Verifying Oh-My-Zsh Installation"

    # Check framework
    if dir_exists "$OMZ_DIR"; then
        log_test "PASS" "Oh-My-Zsh framework directory exists"
    else
        log_test "FAIL" "Oh-My-Zsh framework directory missing"
        all_pass=false
    fi

    # Check plugins
    for plugin_name in "${!OMZ_PLUGINS[@]}"; do
        if dir_exists "$OMZ_PLUGINS_DIR/$plugin_name"; then
            log_test "PASS" "Plugin: $plugin_name"
        else
            log_test "FAIL" "Plugin: $plugin_name missing"
            all_pass=false
        fi
    done

    # Check theme
    if dir_exists "$OMZ_THEMES_DIR/spaceship-prompt"; then
        log_test "PASS" "Spaceship theme"
    else
        log_test "FAIL" "Spaceship theme missing"
        all_pass=false
    fi

    if $all_pass; then
        return 0
    else
        return 1
    fi
}
