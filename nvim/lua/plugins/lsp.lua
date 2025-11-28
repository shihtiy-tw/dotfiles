return {
  {
    'williamboman/mason.nvim',
    -- lazy = false,
    -- config = function()
    --   require("mason").setup {}
    -- end,
    opts = {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    },
    -- use OPTS property to pass the configuration
    -- lazy vim call the setup function for you

    -- config = function()
    -- 	require('mason').setup({})
    -- end
    -- ^^^^^^^^^^^^^^^^ DON'T DO THIS
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  'mhartington/formatter.nvim',
  -- TODO: setup auto complete for python
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    event = 'InsertEnter',
    lazy = false,
    priority = 100,
    config = function()
      require("configs.cmp")
    end
  },
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'cenk1cenk2/schema-companion.nvim' },
      { 'obsidian-nvim/obsidian.nvim' },
    },
    config = function()
      require("configs.lsp")
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  }, {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  config = function()
    require "configs.mason-tool-installer"
  end,
}, {
  'rshkarin/mason-nvim-lint'
}

}


-- mason.nvim will make sure we have access to the language servers.
-- mason-lspconfig to configure the automatic setup of every language server we install.
