require("schema-companion").setup({
  -- if you have telescope you can register the extension
  log_level = vim.log.levels.DEBUG,
  enable_telescope = true,
  formatting = true,
  matchers = {
    -- FIX: Need to debugy why I changed the matchers first and it will change the schemastore?
    -- │ [schema-companion.nvim] [DEBUG] [...azy/schema-companion.nvim/lua/schema-companion/utils.lua:11]: Ensuring schema exists: uri="https://raw.githubusercontent.com/datreeio/CRDs-catalog/ma │
    -- │ [schema-companion.nvim] [DEBUG] [...azy/schema-companion.nvim/lua/schema-companion/utils.lua:15]: Schema does not exist on remote: uri="https://raw.githubusercontent.com/datreeio/CRDs-c │
    -- │ [schema-companion.nvim] [DEBUG] [...y/schema-companion.nvim/lua/schema-companion/context.lua:46]: bufnr=1 client_id=1 no registered matcher matched this file
    --
    -- add your matchers
    -- require("schema-companion.matchers.kubernetes").setup({ version = "master" }),
  },
  schemas = {
    {
      name = "Kubernetes",
      uri = require('kubernetes').yamlls_schema(),
    },
  }
})
