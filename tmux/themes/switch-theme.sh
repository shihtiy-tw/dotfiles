#!/usr/bin/env bash
# Apply the tmux everforest colorscheme for light or dark mode.
#
# Usage: switch-theme.sh [light|dark]
#
# With no argument the mode is detected from the OS, using whichever tool that
# platform provides:
#   Linux -> darkman(1)      https://gitlab.com/WhyNotHugo/darkman
#   macOS -> defaults read -g AppleInterfaceStyle
#
# Called from three places:
#   - darkman hooks in misc/darkman/{dark,light}-mode.d/ (Linux, on transition)
#   - erikw/tmux-dark-notify (macOS, on transition)
#   - tmux.conf at startup, with no argument, to seed a freshly started server

set -o errexit
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

THEME_LIGHT='light-medium'
THEME_DARK='dark-medium'

# TanglingTreats/tmux-everforest, installed by TPM. Keep in sync with
# TMUX_PLUGIN_MANAGER_PATH in tmux.conf. That variable is set via tmux
# set-environment, which does not expand ~, so do it here.
PLUGINS_DIR="${TMUX_PLUGIN_MANAGER_PATH:-$HOME/.tmux/plugins}"
PLUGINS_DIR="${PLUGINS_DIR/#\~/$HOME}"
PLUGIN_DIR="$PLUGINS_DIR/tmux-everforest"

# Remembers the last applied theme so a new tmux server starts in the right
# mode instead of falling back to the plugin's built-in dark default. tmux.conf
# sources this link on startup. The name matches what tmux-dark-notify writes
# on macOS, so both platforms converge on one path.
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/tmux"
STATE_LINK="$STATE_DIR/tmux-dark-notify-theme.conf"

# Echo light|dark, or nothing if the platform's tool cannot answer.
detect_mode() {
	case "$(uname -s)" in
		Darwin)
			# AppleInterfaceStyle only exists in dark mode; unset means light.
			if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = Dark ]; then
				echo dark
			else
				echo light
			fi
			;;
		*)
			# `darkman get` talks to the daemon over the session bus, so it fails
			# when DBUS_SESSION_BUS_ADDRESS is missing from the environment.
			command -v darkman >/dev/null 2>&1 && darkman get 2>/dev/null
			;;
	esac
}

# Recover the previous choice from the state symlink, so a failed detection
# keeps the theme it had rather than snapping to a hardcoded default.
last_mode() {
	case "$(readlink "$STATE_LINK" 2>/dev/null)" in
		*light*) echo light ;;
		*dark*) echo dark ;;
		*) return 1 ;;
	esac
}

mode="${1:-}"
if [ -z "$mode" ]; then
	mode="$(detect_mode)" || :
fi
if [ -z "$mode" ]; then
	mode="$(last_mode)" || mode=dark
	echo "${0##*/}: could not detect the OS colour scheme, keeping '$mode'" >&2
fi

case "$mode" in
	light) variant="$THEME_LIGHT" ;;
	dark) variant="$THEME_DARK" ;;
	*)
		echo "Usage: ${0##*/} [light|dark]" >&2
		exit 1
		;;
esac

theme_conf="$PLUGIN_DIR/tmux-everforest-$variant.conf"
if [ ! -r "$theme_conf" ]; then
	echo "Theme is not readable: $theme_conf" >&2
	echo "Is TanglingTreats/tmux-everforest installed? Run <prefix>I or make/modules/common/tmux-tpm.sh" >&2
	exit 2
fi

mkdir -p "$STATE_DIR"
ln -sfn "$theme_conf" "$STATE_LINK"

# Apply to the running server, if there is one. Probing with set-option rather
# than has-session on purpose: when tmux.conf calls this during server startup
# no session exists yet, but the server is already there to accept options.
# Setting @tmux-everforest keeps the plugin's own entry point in agreement, so a
# later reload of it does not fall back to its dark-medium default.
if tmux set-option -gq @tmux-everforest "$variant" 2>/dev/null; then
	tmux source-file "$theme_conf"
fi
