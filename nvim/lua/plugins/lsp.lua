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
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
    },
    config = function(_, opts)
      local cmp = require('cmp')
      local cmp_keybind = {
        ['<S-TAB>'] = cmp.mapping.select_prev_item(),
        ['<TAB>'] = cmp.mapping.select_next_item(),
        -- complete
        -- ['<TAB'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        -- cancel
        ['<A-,>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ['<ENTER>'] = cmp.mapping.confirm({
          select = true,
          behavior = cmp.ConfirmBehavior.Replace
        }),
        -- ['<C-s>'] = cmp.mapping.confirm({
        --   select = true,
        --   behavior = cmp.ConfirmBehavior.Replace
        -- }),
      }

      cmpsetup = {
        snippet = {
          expand = function(args)
            -- require('luasnip').lsp_expand(args.body)
          end,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            -- { name = 'luasnip' },
          },
          {
            { name = 'buffer' },
            { name = 'path' }
          }),

        mapping = cmp_keybind,
      }
      cmp.setup(cmpsetup)
      cmp.setup.cmdline({ '/', '?' }, {
        sources = {
          { name = 'buffer' }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          {
            { name = 'path' }
          },
          {
            { name = 'cmdline' }
          }
        )
      })
    end
    -- config = function()
    --   local cmp = require('cmp')
    --
    --   cmp.setup({
    --     sources = {
    --       { name = 'nvim_lsp' },
    --     },
    --     mapping = cmp.mapping.preset.insert({
    --       ['<C-Space>'] = cmp.mapping.complete(),
    --       ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    --       ['<C-d>'] = cmp.mapping.scroll_docs(4),
    --     }),
    --     snippet = {
    --       expand = function(args)
    --         vim.snippet.expand(args.body)
    --       end,
    --     },
    --   })
    -- end
  },
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    config = function()
      require "configs.lsp"
    end
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
