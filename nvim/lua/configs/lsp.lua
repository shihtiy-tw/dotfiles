-- local lsp_zero = require('lsp-zero')
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
  local clients = vim.lsp.get_clients({ bufnr = 0 })
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
-- lsp_zero.extend_lspconfig({
--   sign_text = true,
--   lsp_attach = lsp_attach,
--   capabilities = lsp_capabilities
-- })

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
  automatic_enable = true,

})
