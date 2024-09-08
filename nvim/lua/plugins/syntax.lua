return {
     {
    'williamboman/mason.nvim',
      lazy = false,
      config = true,
      config = function()
        require("mason").setup {}
      end,
    },
    "williamboman/mason-lspconfig.nvim",
    'mhartington/formatter.nvim',
    {
    'VonHeikemen/lsp-zero.nvim',
      branch = 'v4.x',
      lazy = true,
      config = false,
      config = function()
        require("lsp-zero").setup {}
      end,
    },
    -- TODO: setup auto complete for python
    {'hrsh7th/cmp-nvim-lsp'},
    {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        sources = {
          {name = 'nvim_lsp'},
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
      })
    end
  },
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      require "configs.lspconfig"
    end
  }
}


-- mason.nvim will make sure we have access to the language servers.
-- mason-lspconfig to configure the automatic setup of every language server we install.
