# Tmux Configuration

## Highlights
- **Resilience**: `tmux-resurrect` saves session state and `tmux-continuum` restores it,
  saving every 5 minutes.
- **Navigation**: Vim-style movement that works with or without the prefix — `h`/`l`
  between **windows**, `j`/`k` between **panes**.
- **Theming**: Follows the OS light/dark mode automatically; `make dark` / `make light`
  set the OS mode and tmux picks it up.

## Structure
- `tmux.conf`: The main config file, symlinked to both `~/.tmux.conf` and
  `~/.config/tmux/tmux.conf`.
- `themes/switch-theme.sh`: The theme entry point. Resolves the everforest variant from
  the TPM plugin directory and symlinks it to
  `~/.local/state/tmux/tmux-dark-notify-theme.conf`, which `tmux.conf` sources. Runs on
  every server start with no argument, in which case it detects the current OS mode
  itself.
- `themes/*.conf`: Legacy standalone theme files. Nothing sources these any more — the
  everforest ones come from the plugin, and the gruvbox pair points at a clone path that
  no longer exists.

## Critical Keybindings
**Prefix:** `Ctrl + a`

| Key | Action |
| :--- | :--- |
| `Prefix + S` | **New Session** (prompts for a name, attaches if it exists) |
| `Prefix + [` | Copy Mode (Vim style) |
| `Prefix + h/l` or `Ctrl + h/l` | Previous / next **window** |
| `Prefix + j/k` or `Ctrl + j/k` | Previous / next **pane** |
| `Prefix + H/J/K/L` | Resize Panes |
| `Prefix + " / %` | Split, keeping the current pane's directory |
| `Prefix + P / N` | Broadcast typing to all panes on / off |
| `Prefix + Ctrl + f` | tmux-fzf |
| `Space` (easy-motion prefix) | Jump to a word |
| `Prefix + R` | Reload the config |
| `Prefix + I` | Install Plugins (TPM) |

The `Ctrl + h/j/k/l` forms are bound in the root table, so they work without the prefix.
Note that plain `l` is rebound to next-window, so it is **not** tmux's default
`last-window`.

## Plugins via TPM
- **tmux-sensible**: Baseline defaults.
- **tmux-resurrect**: Saves session state.
- **tmux-continuum**: Restores it on start and auto-saves every 5 minutes.
- **tmux-yank**: System clipboard integration.
- **tmux-fzf**: Fuzzy finding for session switching, launched with `Prefix + Ctrl + f`.
- **tmux-everforest**: The theme itself.
- **tmux-dark-notify**: Reports macOS light/dark changes to tmux. On Linux the same job
  is done by `darkman`.
- **tmux-easy-motion**: Word jumping, prefixed with `Space`.
- **kube-tmux**: Current Kubernetes context in the status line.

## Theming

Theme selection follows the operating system rather than being set here:

- On start, `tmux.conf` runs `themes/switch-theme.sh` with no argument. The script detects
  the mode — `darkman` on Linux, `AppleInterfaceStyle` on macOS — and links the matching
  everforest variant into `~/.local/state/tmux/tmux-dark-notify-theme.conf`.
- `make dark` / `make light` change the *OS* mode via `make/color-theme.sh`; the watchers
  (`darkman` hooks on Linux, tmux-dark-notify on macOS) then re-run the script, so running
  tmux servers follow without restarting.

## Note

The block at the end of `tmux.conf` was appended by `agent-deck` and overrides earlier
settings in the same file: it sets `default-terminal` to `tmux-256color`, raises
`history-limit` to 50000, and enables `mouse on` with wheel-scroll copy-mode entry and
`xclip` drag-to-copy. If a setting near the top of the file seems to have no effect,
check there first.
