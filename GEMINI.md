# dotfiles — Gemini Context

See [AGENTS.md](./AGENTS.md) for full context.

## Gemini-Specific Notes

- Use `gemini --model gemini-2.0-flash` for quick config lookups
- Neovim Avante.nvim configured with Gemini as primary model
- opencode.jsonc has Antigravity Gemini 3 Pro/Flash models

## Issue Tracking Protocol

When you encounter any error, unexpected behavior, or TODO during this session:

1. **Check first**: Does an Issue Note already exist at `~/Brainiverse/Brainiverse/Effort/Issues/` for this problem?
2. **Create if missing**: Create a file at `~/Brainiverse/Brainiverse/Effort/Issues/<Verb Description>.md` with `kind: issue` frontmatter.
3. **Set lab field**: Use `lab: dotfiles` in frontmatter.
4. **Then continue**: Proceed with your fix.

**Issue Notes location**: `~/Brainiverse/Brainiverse/Effort/Issues/`
**Status flow**: Open → Investigating → Resolved | Won't Fix → Closed
