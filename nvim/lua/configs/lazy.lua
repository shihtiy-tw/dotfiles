-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    -- { import = "plugins" },

    -- General
    -- ----------------------------
    -- enhanced search
    { import = "plugins.telescope" },
    -- autopair plugin that supports multiple characters.
    { import = "plugins.autopairs" },
    -- auto save
    { import = "plugins.autosave" },
    -- auto create bullets
    { import = "plugins.bullets" },
    -- input method select
    { import = "plugins.im-select" },
    -- show indent
    { import = "plugins.indent-blankline" },
    -- bottom line
    { import = "plugins.lualine" },
    -- Library of 40+ independent Lua modules
    { import = "plugins.mini" },
    -- a clipboard manager
    { import = "plugins.neoclip" },
    -- enhanced notification
    { import = "plugins.notify" },
    -- enhanced neovim fold feature
    { import = "plugins.nvim-ufo" },
    -- syntax highlighting for rainbow parentheses
    { import = "plugins.rainbow-delimiters" },
    -- seartch TODO, BUG etc
    { import = "plugins.todo-comments" },
    -- show key mappings
    { import = "plugins.which-key" },
    -- enhanced nvim cmdline
    { import = "plugins.noice" },
    -- jump among windws
    { import = "plugins.window" },
    -- show potential movement
    { import = "plugins.precognition" },
    -- show hover info
    { import = "plugins.hover" },
    -- show doc info
    { import = "plugins.docs" },
    -- zoom in mode
    { import = "plugins.zen" },

    -- Notes
    -- ----------------------------
    -- Notion
    { import = "plugins.notion" },
    -- Obsidian
    { import = "plugins.obsidian" },
    -- Obsidian sync scrolling
    { import = "plugins.obsidian-bridge" },

    -- Search
    -- ----------------------------
    { import = "plugins.fzf" },

    -- Navegation
    -- ----------------------------
    -- add things to list
    { import = "plugins.harpoon2" },
    -- easymotion on lua
    { import = "plugins.hop" },
    -- Quickly jump between next and previous NeoVim buffer, tab, file, quickfix, diagnostic
    { import = "plugins.nap" },
    -- navegate with vim key
    { import = "plugins.oil" },
    -- Open alternative files for the current buffer
    { import = "plugins.other" },
    -- tree
    { import = "plugins.tree" },
    -- open a url
    { import = "plugins.url-open" },
    -- use yazi file manager
    { import = "plugins.yazi" },

    -- Theme
    -- ----------------------------
    { import = "plugins.gruvbox" },
    { import = "plugins.solarized" },

    -- Git
    -- ----------------------------
    -- fugitive, diffview
    { import = "plugins.git" },
    { import = "plugins.gitsigns" },

    -- Syntax
    -- ----------------------------
    { import = "plugins.nvim-treesitter" },
    -- mason-lsp
    { import = "plugins.lsp" },
    -- improve lsp experences in neovim
    { import = "plugins.lspsaga" },
    -- mason-conform
    { import = "plugins.formatter" },
    -- rename for LSP
    { import = "plugins.inc-rename" },
    -- java
    { import = "plugins.java" },
    -- selecting schema for yaml and json
    { import = "plugins.schema-companion" },
    { import = "plugins.schemastore" },
    -- snippets
    { import = "plugins.snippets" },
    -- trouble
    { import = "plugins.trouble" },
    -- code outline window
    { import = "plugins.aerial" },
    { import = "plugins.outline" },
    -- A task runner and job management plugin
    { import = "plugins.overseer" },
    -- enhanced notification for lsp
    { import = "plugins.fidget" },
    -- preview lsp action
    { import = "plugins.goto-preview" },

    -- Kubernetes
    -- ----------------------------
    -- use k9s in neovim
    { import = "plugins.kube-utils" },
    -- fetches resource definitions from your cluster and feeds them to yamlls
    { import = "plugins.kubernetes" },
    -- use kustomize
    { import = "plugins.kustomize" },
    -- use kubectl
    { import = "plugins.kubectl" },

    -- Markdown
    -- ----------------------------
    { import = "plugins.markdown" },
    -- render
    -- { import = "plugins.render-markdown" },
    { import = "plugins.markview" },
    -- tables
    { import = "plugins.easytables" },
    { import = "plugins.markdown-table" },
    -- image
    { import = "plugins.image" },
  },


  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
