# dotfiles — Claude Context

See [AGENTS.md](./AGENTS.md) for full context.

## Claude-Specific Notes

- Config monorepo for Linux/macOS dev environment
- Symlink-based installation via `make init`
- Neovim config uses Lua (Lazy.nvim + LSP-Zero + Avante.nvim)
- AI config in `opencode/opencode.jsonc`

## Issue Tracking Protocol

When you encounter any error, unexpected behavior, or TODO during this session:

1. **Check first**: Does an Issue Note already exist at `~/Brainiverse/Brainiverse/Effort/Issues/` for this problem?
2. **Create if missing**: Create a file at `~/Brainiverse/Brainiverse/Effort/Issues/<Verb Description>.md` with `kind: issue` frontmatter.
3. **Set lab field**: Use `lab: dotfiles` in frontmatter.
4. **Then continue**: Proceed with your fix.

**Issue Notes location**: `~/Brainiverse/Brainiverse/Effort/Issues/`
**Status flow**: Open → Investigating → Resolved | Won't Fix → Closed
