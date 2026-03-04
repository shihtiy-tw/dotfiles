# dotfiles Agent Context

**Domain**: System configuration and developer tooling
**Location**: `/home/yst/dotfiles`
**Remote**: github.com/shihtiy-tw/dotfiles
**Type**: Config monorepo

---

## YOU ARE HERE

dotfiles/
├── alacritty/    # Terminal emulator config
├── aws/          # AWS CLI & Amazon Q
├── bash/         # Bash framework & aliases
├── ghostty/      # Ghostty terminal config
├── git/          # Git config & commit templates
├── kitty/        # Kitty terminal config
├── make/         # Installation scripts & orchestration
├── misc/         # Darkman & Xmodmap
├── nix/          # Nix flakes config
├── nvim/         # Neovim (Lua, Avante.nvim, LSP-Zero)
├── opencode/     # AI Agent config (opencode.jsonc)
├── tmux/         # Tmux & TPM
├── vim/          # Legacy Vim config
└── zsh/          # Zsh framework & aliases

---

## AI Methodology

This repo uses **GSD** (get-shit-done-cc) for lightweight config changes.
For complex multi-tool changes, escalate to SpecKit.

Methodology reference: ~/Brainiverse/Brainiverse/Effort/Projects/Cultivation/Labs/METHODOLOGY.md

---

## Safety Rules

- ALWAYS test symlinks before committing: `make init --dry-run` if available
- Backup existing configs before symlinking: `make backup`
- Test in a new shell/terminal before closing current session
- Never commit secrets or API keys
- Use `git diff` before every commit

---

## opencode Configuration

Main config: `opencode/opencode.jsonc`

Active plugins:
- `oh-my-opencode` — Agent harness, multi-model orchestration
- `@plannotator/opencode` — Planning assist
- `opencode-gemini-auth` — Gemini via Google auth
- `opencode-antigravity-auth` — Antigravity Gemini + Claude access

---

## Issue Tracking Protocol

When you encounter any error, unexpected behavior, or TODO during this session:

1. **Check first**: Does an Issue Note already exist at `~/Brainiverse/Brainiverse/Effort/Issues/` for this problem?
2. **Create if missing**: Create a file at `~/Brainiverse/Brainiverse/Effort/Issues/<Verb Description>.md` with `kind: issue` frontmatter.
3. **Set lab field**: Use `lab: dotfiles` in frontmatter.
4. **Then continue**: Proceed with your fix.

**Issue Notes location**: `~/Brainiverse/Brainiverse/Effort/Issues/`
**Status flow**: Open → Investigating → Resolved | Won't Fix → Closed
