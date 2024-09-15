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

require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'dockerls',
    'jsonls',
    'gopls',
    'dockerls',
    'yamlls',
    'bashls',
    'marksman'
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

-- https://github.com/hyperter96/nvim/blob/94b6824cd57c13eec1467c10f9973f4e70ff0ff7/lua/plugins/extras/lang/yaml.lua#L69
require("lspconfig").yamlls.setup(require("schema-companion").setup_client({
  -- lazy-load schemastore when needed
  on_new_config = function(new_config)
    new_config.settings.yaml.schemas =
        vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  end,
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
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      -- schemaStore = {
      --   -- Must disable built-in schemaStore support to use
      --   -- schemas from SchemaStore.nvim plugin
      --   enable = true,
      --   -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
      --   url = "https://www.schemastore.org/api/json/catalog.json",
      -- },
      schemas = require('schemastore').yaml.schemas {
        -- select subset from the JSON schema catalog
        extra = {
          {
            description = 'Current Kubernetes Schemas',
            fileMatch = "k8s-*.yaml",
            name = 'Kubernetes',
            url = require('kubernetes').yamlls_schema(),
          },
        },
        ignore = {
          "dotnet-tools.json",
          "dotnet Release Index manifest",
          "Crowdsec scenario config"
        }
        -- select = {
        --   'kustomization.yaml',
        --   'docker-compose.yml'
        -- },
      },
      -- schemas = {
      -- ["~/.config/nvim/schemas/protolint.json"] = ".protolint.{yml,yaml}",
      -- ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
      -- ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      -- ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] =
      -- "azure-pipelines.yml",
      -- ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      -- ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
      -- ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
      -- ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
      -- ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
      -- ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
      -- ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] =
      -- "*gitlab-ci*.{yml,yaml}",
      -- ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
      -- "*api*.{yml,yaml}",
      -- ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
      -- "*docker-compose*.{yml,yaml}",
      -- ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
      -- "*flow*.{yml,yaml}",
      -- },
    },
  },
}))
