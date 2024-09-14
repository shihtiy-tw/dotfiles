local lsp_zero = require('lsp-zero')

-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(client, bufnr)
  local opts = { buffer = bufnr }

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities()
})

require('mason').setup({})

require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'dockerls',
    'jsonls',
    'gopls',
    'dockerls',
    'yamlls',
    'bashls'
  },
  -- ensure_installed = {
  --   'sumneko_lua',
  --   'rust_analyzer',
  --   'clangd',
  --   'neocmake',
  --   'dockerls',
  --   'html',
  --   'jsonls',
  --   'tsserver',
  --   'pylsp',
  --   'rnix',
  --   'sqlls',
  --   'taplo',
  --   'vuels',
  --   'lemminx',
  --   'yamlls'
  -- },
  automatic_installation = true,
  handlers = {
    -- this first function is the "default handler"
    -- it applies to every language server without a "custom handler"
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  }
})


-- yamlls config
-- https://www.arthurkoziel.com/json-schemas-in-neovim/

require("lspconfig").yamlls.setup(require("schema-companion").setup_client({
  -- TODO: check how to exclude the file name so the k8s yaml will not be mapped to other schema
  --
  schemas = require('schemastore').yaml.schemas {
    -- select subset from the JSON schema catalog
    select = {
      'kustomization.yaml',
      'docker-compose.yml'
    },
  },

  settings = {
    formatting = false,

    yaml = {
      schemas = {
        -- use this if you want to match all '*.yaml' files
        [require('kubernetes').yamlls_schema()] = "k8s-*.yaml",
        -- or this to only match '*.<resource>.yaml' files. ex: 'app.deployment.yaml', 'app.argocd.yaml', ...
        [require('kubernetes').yamlls_schema()] = require('kubernetes').yamlls_filetypes()
      }
    }
  }
}
--
-- your yaml language server configuration
-- settings = {
--   yaml = {
--   NOTE: this will set a 1.22 global one
--
--     schemas = { kubernetes = "globPattern" },
--   }
-- }
))

-- local cfg = require("schema-companion").setup {
--
--   -- Additional schemas available in Telescope picker
--   schemas = {
--     {
--       name = "Flux GitRepository",
--       uri = "https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/gitrepository-source-v1.json",
--     },
--     {
--       name = "Kubernetes 1.29",
--       uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.3-standalone-strict/all.json",
--     }
--   },
--
--   -- Pass any additional options that will be merged in the final LSP config
--   -- Defaults: https://github.com/someone-stole-my-name/yaml-companion.nvim/blob/main/lua/yaml-companion/config.lua
--   lspconfig = {
--     settings = {
--       yaml = {
--         validate = true,
--         schemaStore = {
--           enable = false,
--           url = "",
--         },
--         schemas = {
--           ['https://json.schemastore.org/github-workflow.json'] = '.github/workflows/*.{yml,yaml}',
--           ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.3-standalone-strict/all.json'] = 'deployment.yaml',
--         }
--       }
--     }
--   }
-- }

-- require("lspconfig")["yamlls"].setup(cfg)



-- cmp config

local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
  -- snippet = {
  --   expand = function(args)
  --     -- You need Neovim v0.10 to use vim.snippet
  --     vim.snippet.expand(args.body)
  --   end,
  -- },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({}),
})
