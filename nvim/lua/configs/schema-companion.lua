require("schema-companion").setup({
  -- log_level = vim.log.levels.DEBUG,
  log_level = vim.log.levels.INFO,
  -- if you have telescope you can register the extension
  enable_telescope = true,
  -- formatting = true,
  matchers = {
    -- add your matchers
    -- require("schema-companion.matchers.kubernetes").setup({ version = "master" }),
  },
  schemas = {
    {
      name = "Kubernetes v1.30",
      uri =
      "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.3-standalone-strict/_definitions.json",
    },
    {
      name = "Kubernetes Main",
      uri = require('kubernetes').yamlls_schema()
    },
    {
      name = "Protolint",
      uri = "~/.config/nvim/schemas/protolint.json",
    },
  },
})
