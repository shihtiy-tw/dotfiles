return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = { 'tree-sitter-grammars/tree-sitter-markdown', "latex-lsp/tree-sitter-latex", },
  -- https://github.com/omardoescode/nvim-dotfiles/blob/875ea13e0f4127d62be3562b9ea39a079959ac9b/lua/omar/plugins/treesitter.lua#L7
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({
      -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      -- ensure these language parsers are installed
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
        "cpp",
        "java",
        "cmake",
        "terraform",
        "hcl",
        "python",
        "ninja",
        "rst"
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
