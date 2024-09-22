local lsp_zero = require('lsp-zero')
local lsp_config = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()


-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(client, bufnr)
  local opts = { buffer = bufnr }

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
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

-- TODO: tirgger LSP based on Filepath (markdown)
-- https://www.reddit.com/r/neovim/comments/13j71qz/how_to_activate_specific_lsp_based_on_directory/

-- TODO: install markdown-oxide for obsidian
-- https://github.com/Feel-ix-343/markdown-oxide

require('mason-lspconfig').setup({
  -- See mapping
  -- https://github.com/williamboman/mason-lspconfig.nvim/blob/25c11854aa25558ee6c03432edfa0df0217324be/lua/mason-lspconfig/mappings/server.lua
  ensure_installed = {
    'lua_ls',
    'dockerls',
    'jsonls',
    'gopls',
    'dockerls',
    'yamlls',
    'bashls',
    'markdown_oxide'
    -- 'marksman',
    -- autotools_ls is broken
    -- https://github.com/jwmatthews/treesitter_example/issues/1
    -- 'autotools_ls',
    -- for java, just use java.nvim
    -- 'java_language_server'
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
      lsp_config[server_name].setup({})
    end,
  }
})

-- require("lspconfig").yamlls.setup {
--   settings = {
--     yaml = {
--       -- validate = true,
--       -- completion = true,
--       schemas = {
--         kubernetes = "k8s-*.yaml",
--         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
--         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
--         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
--         ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
--         ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
--         ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
--         ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
--       },
--     },
--   },
-- }

-- yaml
-- https://github.com/hyperter96/nvim/blob/94b6824cd57c13eec1467c10f9973f4e70ff0ff7/lua/plugins/extras/lang/yaml.lua#L69
require("lspconfig").yamlls.setup(require("schema-companion").setup_client({
  -- lazy-load schemastore when needed
  -- on_new_config = function(new_config)
  --   new_config.settings.yaml.schemas =
  --       vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  -- end,
  settings = {
    yaml = {
      format = {
        enable = true,
      },
      validate = true,
      completion = true,
      keyOrdering = false,
      schemaStore = {
        -- Must disable built-in schemaStore support to use
        -- schemas from SchemaStore.nvim plugin
        enable = true,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        -- yaml server has built-in kubernetes support
        -- https://github.com/redhat-developer/yaml-language-server/pull/611/files
        -- The schema source can be changed here
        -- ~/.local/share/nvim/mason/packages/yaml-language-server/node_modules/yaml-language-server/out/server/src/languageservice/utils/schemaUrls.js
        -- TODO: how to use schemastore to contain the built-in kubernetes
        -- TODO: Can trigger schema based on path?
        kubernetes = "k8s-*.yaml",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
      },
    },
  },
}))


-- java
-- https://github.com/nvim-java/nvim-java?tab=readme-ov-file#custom-configuration-instructions
lsp_config.jdtls.setup({})

-- Makefiles
-- https://github.com/MrTreev/nvim-config/blob/eb4e7dbe08a82d12ca896032f143967baad46571/lua/core/lsp/autotools_ls.lua#L4
-- lsp_config.autotools_ls.setup {
--   capabilities = lsp_capabilities,
-- }

-- https://github.com/hyperter96/nvim/blob/94b6824cd57c13eec1467c10f9973f4e70ff0ff7/lua/plugins/extras/lang/yaml.lua#L69
-- require("lspconfig").yamlls.setup(require("schema-companion").setup_client({
--   -- lazy-load schemastore when needed
--   -- on_new_config = function(new_config)
--   --   new_config.settings.yaml.schemas =
--   --       vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
--   -- end,
--   settings = {
--     yaml = {
--       -- format = {
--       --   enable = true,
--       -- },
--       validate = true,
--       completion = true,
--       keyOrdering = false,
--       schemaStore = {
--         -- Must disable built-in schemaStore support to use
--         -- schemas from SchemaStore.nvim plugin
--         enable = false,
--         -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
--         url = "",
--       },
--       -- schemaStore = {
--       --   -- Must disable built-in schemaStore support to use
--       --   -- schemas from SchemaStore.nvim plugin
--       --   enable = true,
--       --   -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
--       --   url = "https://www.schemastore.org/api/json/catalog.json",
--       -- },
--       schemas = require('schemastore').yaml.schemas()
--     },
--   },
-- }))
