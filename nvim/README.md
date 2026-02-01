# Neovim Configuration

## Highlights
- **AI-Native Workflow**: Deep integration with **Avante.nvim** using `gemini-cli` and `ollama` for agentic coding.
- **Modern Lua**: Built entirely on Lua with `lazy.nvim` for lightning-fast startup.
- **LSP & Tools**: Pre-configured for Python, Go, Lua, and more via `lsp-zero` and `mason`.

## Structure
- `init.lua`: Bootstraps `lazy.nvim`.
- `lua/configs/`: Plugin configurations.
  - `avante.lua`: **Gemini** & **Ollama** provider settings + MCP Tools.
  - `lsp.lua`: Language Server Protocol settings.
  - `keymaps.lua`: Centralized keybindings.

## AI Integration
This config is bleeding-edge:
- **Provider**: Defaults to **Gemini Flow** for complex reasoning.
- **Local Fallback**: **Qwen 2.5 Coder** (via Ollama) for fast, free autocomplete.
- **MCP**: Model Context Protocol integration via `mcphub` for connecting AI to external tools.

## Critical Keybindings
| Key | Action |
| :--- | :--- |
| `<leader>f` | Telescope Files (Fuzzy Find) |
| `<leader>a` | **Avante AI** Actions (Ask/Edit) |
| `<leader>g` | Git (Fugitive/LazyGit) |
| `<C-a>` | CodeCompanion (Inline AI) |

## Prerequisites
- Neovim >= 0.10.0
- `ripgrep`, `fd`
- `ollama` (optional, for local AI)

## Plugin Spotlight
- **Avante.nvim**: Cursor-aware AI coding assistant.
- **Lazy.nvim**: Package manager.
- **Telescope**: Fuzzy finder over lists (files, buffers, etc).
- **Harpoon**: Quick file navigation.
