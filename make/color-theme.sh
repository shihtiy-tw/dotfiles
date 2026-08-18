#!/usr/bin/env bash
################################################################################
# Colour theme switcher - move the desktop between light and dark mode.
#
# Usage: color-theme.sh light|dark    (normally via `make light` / `make dark`)
#
# The OS is the single source of truth for the mode, because that is what every
# "follow the system theme" watcher reads. Each platform exposes it differently:
#
#   Linux -> darkman(1),  which then runs misc/darkman/{dark,light}-mode.d/
#   macOS -> System Events appearance preferences, watched by dark-notify(1)
#
# Setting it there means anything already following the system (Plasma, the
# wallpaper, tmux via tmux/themes/switch-theme.sh) reacts on its own. Tools with
# no watcher of their own are updated directly below.
################################################################################

set -o errexit
set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
DOTFILES="$(dirname "$SCRIPT_DIR")"

source "${SCRIPT_DIR}/modules/helpers/logger.sh"

mode="${1:-}"
case "$mode" in
	light | dark) ;;
	*)
		log_error "Invalid colour scheme: '${mode}'"
		echo "Usage: ${0##*/} light|dark" >&2
		exit 1
		;;
esac

################################################################################
# OS MODE
################################################################################

# Ask the OS to change mode. Deliberately uses uname rather than $OS, which is
# only exported by zsh/env.zsh and so is missing whenever make is not run from
# an interactive zsh.
set_os_mode() {
	case "$(uname -s)" in
		Darwin)
			local dark_mode=false
			[ "$mode" = dark ] && dark_mode=true

			# This is what make/mac/ToggleDarkMode.scpt does internally, but set
			# rather than toggled, so running it twice is not a surprise. Needs
			# Automation permission for the calling terminal on first run.
			safe_exec "macOS: set dark mode to ${dark_mode}" \
				osascript -e "tell application \"System Events\" to tell appearance preferences to set dark mode to ${dark_mode}"
			;;
		*)
			if ! command_exists darkman; then
				log_warn "darkman not installed, only updating this repo's tools"
				log_warn "install it to keep the desktop and tmux in sync: https://gitlab.com/WhyNotHugo/darkman"
				return 0
			fi

			# Runs the hooks in misc/darkman/{dark,light}-mode.d/, which set the
			# Plasma look-and-feel, the wallpaper, and the tmux theme.
			safe_exec "darkman: set ${mode} mode" darkman set "$mode"
			;;
	esac
}

################################################################################
# TOOLS
################################################################################

# tmux follows the OS on its own, but apply it here too so `make dark` still
# works when darkman is not running. switch-theme.sh is idempotent.
set_tmux_theme() {
	safe_exec "tmux: apply ${mode} theme" \
		"${DOTFILES}/tmux/themes/switch-theme.sh" "$mode"
}

# kitty has no system-theme watcher here, so swap the file that kitty.conf
# includes and poke running instances to re-read their config.
set_kitty_theme() {
	local theme_file
	if [ "$mode" = dark ]; then
		theme_file="${DOTFILES}/kitty/gruvbox_dark.conf"
	else
		theme_file="${DOTFILES}/kitty/Solarized_Light.conf"
	fi

	if ! dir_exists "${HOME}/.config/kitty"; then
		log_skip "kitty: ~/.config/kitty does not exist"
		return 0
	fi

	ln -sfn "$theme_file" "${HOME}/.config/kitty/theme.conf"
	log_success "kitty: theme.conf -> $(basename "$theme_file")"

	# kitty reloads its config on SIGUSR1; without this the new theme only
	# shows up in windows started from now on.
	if command_exists pkill && pkill -USR1 -x kitty 2>/dev/null; then
		log_info "kitty: reloaded running instances"
	fi
}

# Exports $THEME for anything that wants to branch on the mode. The file is
# gitignored, so rewriting it on every switch does not dirty the repo.
# zsh/zshrc sources it if it exists, so a new shell picks up the current mode.
# Already-running shells do not - they would need to re-source it themselves.
set_zsh_theme() {
	echo "export THEME=${mode}" >"${DOTFILES}/zsh/theme.zsh"
	log_success "zsh: theme.zsh exports THEME=${mode}"
}

################################################################################
# MAIN
################################################################################

log_section "Switching to ${mode} mode"

# `|| :` on each step: safe_exec already logs and swallows failures, but it
# returns the failed exit code, which errexit above would otherwise turn into an
# abort. One unavailable tool should not stop the rest from being themed.
set_os_mode || :
set_tmux_theme || :
set_kitty_theme || :
set_zsh_theme || :

log_success "Done: ${mode} mode"
