# Neovim Configuration

## Highlights
- **Modern Lua**: Built on Lua with `lazy.nvim`, ~75 plugin specs loaded explicitly.
- **LSP & Tools**: `mason` + `mason-lspconfig` + `nvim-lspconfig`, with `nvim-cmp` for
  completion, `nvim-lint` for linting and `formatter.nvim` for formatting.
- **AI**: `opencode.nvim`, wired into `blink.cmp` and telescope.
- **Kubernetes / YAML heavy**: `kubectl.nvim`, `kube-utils`, `schema-companion`,
  `schemastore`, plus a bundled eksctl schema.
- **Notes**: `obsidian.nvim`, `obsidian-bridge`, `notion`, `iwe`.
- **Follows the OS theme**: everforest via `auto-dark-mode.nvim`.

## Structure

```text
nvim/
├── init.lua                 # requires the five configs modules below
├── lua/configs/
│   ├── settings.lua         # options; also disables the node/perl/python3/ruby providers
│   ├── lazy.lua             # THE plugin list — every `{ import = ... }` lives here
│   ├── keymaps.lua          # centralized keybindings and which-key groups
│   ├── themes.lua
│   ├── windows.lua
│   ├── lsp.lua              # server list and on-attach keymaps
│   ├── formatter/, lint/, schema/   # markdownlint, yamllint, eksctl schema
│   └── avante.lua, codecompanion.lua, octo.lua, ...
├── lua/plugins/             # ~80 individual plugin specs
├── lua/after/lsp/           # per-server overrides: helm_ls, jsonls, yamlls
├── init.vim + vimscript/    # legacy pre-Lua config, not loaded by init.lua
└── lua/plugins/opencode.lua.txt   # stale scratch copy, not loaded
```

**`lua/configs/lazy.lua` is the source of truth for what is enabled.** The blanket
`{ import = "plugins" }` is commented out (`lazy.lua:28`), so a file existing in
`lua/plugins/` means nothing on its own — it has to be imported by name. Several are
present but deliberately not imported: `avante`, `codecompanion`, `render-markdown`,
`gruvbox`, `solarized`, `kubernetes`, `kustomize`, `rainbow-delimiters`.

## AI Integration

The active AI plugin is **`opencode.nvim`** (`sudo-tee/opencode.nvim`), imported at
`lazy.lua:102`, with `blink.cmp` completion, a telescope picker for file mentions, and
`render-markdown` scoped to its output buffer.

`mcphub` is loaded (`lazy.lua:104`), but nothing currently consumes it: its only two
consumers in this config are the avante and codecompanion extensions, both of which are
disabled.

**Avante and CodeCompanion are not installed.** `lazy.lua:100-101` comments out both
imports and `plugins/codecompanion.lua:3` also sets `enabled = false`. Their config
modules — `configs/avante.lua` (gemini-cli provider, `qwen2.5-coder:7b` via ollama) and
`configs/codecompanion.lua` — survive as dead code, as do the commented-out `<leader>a`
and `<C-a>` mappings at `keymaps.lua:582-647`. Re-enabling means uncommenting the imports,
those keymaps, and installing whichever CLI the provider needs.

## Language servers

`ensure_installed` in `configs/lsp.lua`: `lua_ls`, `dockerls`, `jsonls`, `gopls`,
`yamlls`, `bashls`, `terraformls`, `basedpyright`. `lua/after/lsp/` overrides `helm_ls`,
`jsonls` and `yamlls`.

`lsp-zero` is **not** used. Every call to it in `configs/lsp.lua` is commented out and
there is no plugin spec for it; the surviving reference is a doc URL at `init.lua:1`.
Setup is plain `mason-lspconfig` + `nvim-lspconfig`.

On attach (`configs/lsp.lua:29-38`):

| Key | Action |
| :--- | :--- |
| `K` | Hover |
| `gd` / `gD` | Definition / declaration |
| `gi` / `gt` | Implementation / type definition |
| `gr` / `gs` | References / signature help |
| `<F2>` / `<F3>` / `<F4>` | Rename / format / code action |

## Critical Keybindings

Leader groups, all discoverable through which-key:

| Key | Group |
| :--- | :--- |
| `<leader>f` | Telescope — `<leader>ff` is find-files, `<leader>fl` LSP, `<leader>fg` git |
| `<leader>g` | Git (fugitive); `<leader>go` Octohub |
| `<leader>G` | Gitsigns |
| `<leader>x` | Trouble; `<leader>xp` preview |
| `<leader>O` | Outline |
| `<leader>d` | DAP (debugging) |
| `<leader>r` / `<leader>R` | Rename / other |
| `<leader>i` / `<leader>n` | IWE / Notion |
| `<leader>Km` | kustomize |
| `<leader>L` | Leetcode |

Note `<leader>f` on its own is only the *group* prefix; the file picker is `<leader>ff`.

Harpoon (`keymaps.lua:488-528`):

| Key | Action |
| :--- | :--- |
| `<leader>A` | Add the current file |
| `<C-h>` / `<C-t>` / `<C-n>` / `<C-s>` | Jump to slot 1–4 |
| `<C-S-P>` / `<C-S-N>` | Previous / next in the list |
| `<C-e>` | Telescope picker over the harpoon list |

Also: `,` toggles `nvim-window`, and mini.move uses `HJKL` / `<S-arrows>`.

There is **no LazyGit** in this config — the git stack is fugitive, gitsigns, octo,
octohub, git-dev, diffview and vscode-diff.

## Prerequisites
- Neovim >= 0.10.0 (not enforced anywhere in the config)
- `ripgrep`, `fd`
- A working `git`, plus `make`/`cc` for the telescope-fzf-native build
- The node/perl/python3/ruby remote-plugin providers are deliberately **disabled**
  (`configs/settings.lua:79-82`), so you do not need `pynvim` or `neovim` npm packages.
  Drop the matching line if you ever add a plugin that needs one.
- `ollama` is only needed if you re-enable avante or codecompanion.

## Plugin Spotlight
- **opencode.nvim**: the active AI assistant.
- **Lazy.nvim**: package manager; `rocks.enabled = false`.
- **Telescope** (+ `fzf-lua`): fuzzy finding.
- **Harpoon**: quick file navigation.
- **which-key / noice / nvim-notify / lualine / fidget**: UI.
- **mini.nvim**, **nvim-ufo** (folding), **precognition**, **undotree**, **zen-mode**,
  **neoclip**, **hop**, **nap**, **todo-comments**, **autosave**, **im-select**.
- **oil.nvim / nvim-tree / yazi.nvim**: three file managers, pick your habit.
- **markview.nvim** for markdown rendering, plus `easytables`, `markdown-table`,
  `bullets`, `image.nvim`.
- **trouble / lspsaga / aerial / outline / goto-preview**: diagnostics and navigation.
- **overseer**, **venv-selector**, **leetcode.nvim**, **nvim-dap**.

## Legacy

`init.vim` and `vimscript/` (`general.vimrc`, `keys.vimrc`, `plugins.vimrc`,
`plugin_config.vimrc`, `coc-settings.json`, `efm-langserver-config.yaml`) are the pre-Lua
configuration. `init.lua` does not source them and they are not maintained; the coc→LSP
migration is tracked as an open issue in `.issues/`.
