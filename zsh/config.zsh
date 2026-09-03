# Keybindings and line editor.
#
# The zsh-vim-mode plugin (loaded in omzsh.zsh) owns vi mode: it calls
# `bindkey -v` itself, tracks the keymap, and sets the cursor shape per mode.
# The hand-rolled `bindkey -v`, zle-keymap-select, zle-line-init and preexec
# cursor code that used to live here duplicated and fought with it, so it is
# gone - configure the plugin through the MODE_CURSOR_* variables instead.

# Cursor shape per mode, read by zsh-vim-mode.
MODE_CURSOR_VIINS="blinking bar"
MODE_CURSOR_VICMD="block"
MODE_CURSOR_REPLACE="$MODE_CURSOR_VIINS #ff0000"
MODE_CURSOR_SEARCH="steady underline"
MODE_CURSOR_VISUAL="$MODE_CURSOR_VICMD steady bar"
MODE_CURSOR_VLINE="$MODE_CURSOR_VISUAL"

# `jj` and `jk` are two-key escape sequences, so KEYTIMEOUT cannot be 1 (10ms) -
# that is faster than the pair can physically be typed, which made both bindings
# unusable. 15 = 150ms, the usual compromise.
export KEYTIMEOUT=15

bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins '^ ' vi-cmd-mode
bindkey -M viins '^?' backward-delete-char

# vim keys in the completion menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Edit the current command line in $EDITOR with ctrl-x
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x' edit-command-line

# Use lf to switch directories, bound to ctrl-o. Only defined when lf is actually
# installed - the binding used to fire unconditionally and fail with
# "command not found: lf".
if (( $+commands[lf] )); then
  lfcd() {
    local tmp dir
    tmp="$(mktemp)" || return 1
    lf -last-dir-path="$tmp" "$@"
    if [[ -f $tmp ]]; then
      dir="$(<"$tmp")"
      command rm -f "$tmp"
      [[ -d $dir && $dir != "$PWD" ]] && cd "$dir"
    fi
  }
  bindkey -s '^o' 'lfcd\n'
fi
