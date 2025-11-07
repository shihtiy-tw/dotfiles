local lsp_zero = require('lsp-zero')
local lsp_config = vim.lsp.config
local schema_companion = require("schema-companion")

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)
lsp_capabilities.workspace = {
  didChangeWatchedFiles = {
    dynamicRegistration = true,
  },
}

-- Helper function for codelens
local function check_codelens_support()
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  for _, c in ipairs(clients) do
    if c.server_capabilities.codeLensProvider then
      return true
    end
  end
  return false
end

-- lsp_attach is where you enable features
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

  -- FIX: Moved codelens logic inside on_attach, where 'bufnr' is valid
  -- and it will only run for buffers with an active LSP
  vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'CursorHold', 'BufEnter' }, {
    buffer = bufnr,
    callback = function()
      if check_codelens_support() then
        vim.lsp.codelens.refresh({ bufnr = 0 })
      end
    end
  })
end

-- Configure lsp-zero to use your attach function and capabilities
lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = lsp_capabilities
})

require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'dockerls',
    'jsonls',
    'gopls',
    'dockerls',
    'yamlls',
    'bashls',
    'terraformls',
    'basedpyright',
    'markdown_oxide'
  },
  automatic_installation = true,
  handlers = {
    -- FIX: Use lsp_zero.default_setup as the default handler.
    -- This will apply your lsp_attach and capabilities to ALL servers.
    lsp_zero.default_setup,

    -- FIX: All custom server configs go inside the handlers table.
    yamlls = function()
      -- 1. Get the adapter for the language server
      local yamlls_adapter = require("schema-companion.adapters.http.yamlls").setup({
        -- You can configure schema sources here
        sources = {
          require("schema-companion.sources.lsp").setup(),
          require("schema-companion.sources.matchers.kubernetes").setup(),
        },
      })

      -- 2. Pass the adapter AND your config to setup_client
      lsp_config.yamlls.setup( -- FIX: Use lsp_config, not lspconfig
        schema_companion.setup_client(
          yamlls_adapter,
          {
            -- This table is your ORIGINAL lspconfig setup
            -- FIX: Pass the correct lsp_attach and lsp_capabilities variables
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
            settings = {
              yaml = {
                format = {
                  enable = true,
                },
                validate = true,
                completion = true,
                keyOrdering = false,
                schemaStore = {
                  enable = true,
                  url = "https://www.schemastore.org/api/json/catalog.json",
                },
                schemas = {
                  kubernetes = "k8s-*.yaml",
                  ["file://home/ubuntu/dotfiles/nvim/lua/configs/schema/eksctl-schema.json"] = "eksctl-*.yaml",
                  ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                  ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                  ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
                  ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                  ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                  ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                  ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
                  ["https://raw.githubusercontent.com/shihtiy-tw/amazon-ecs-intellisense-schema/refs/heads/mainline/src/model/schema/schema.json"] =
                  "*task-def.yaml",
                },
              },
            },
          }
        )
      )
    end,

    -- NOTE: All other servers (terraformls, markdown_oxide, basedpyright)
    -- will be set up automatically by lsp_zero.default_setup.
    -- No need to call their .setup() manually at the end of the file.
    -- nvim-java handles jdtls automatically.
  }
})
