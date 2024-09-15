return {
  "cenk1cenk2/schema-companion.nvim",
  optional = false,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "b0o/schemastore.nvim" },
    { 'diogo464/kubernetes.nvim' }
  },
  config = function()
    require("schema-companion").setup({
      -- log_level = vim.log.levels.DEBUG,
      -- if you have telescope you can register the extension
      enable_telescope = true,
      matchers = {
        -- add your matchers
        -- require("schema-companion.matchers.kubernetes").setup({ version = "master" }),
      },
      schemas = {
        {
          name = "Kubernetes Main",
          uri = require('kubernetes').yamlls_schema()
        },
        {
          name = "Kubernetes v1.30",
          uri =
          "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.3-standalone-strict/all.json",
        },
        {
          name = "Protolint",
          uri = "~/.config/nvim/schemas/protolint.json",
        },
      },
    })
  end,
}

-- return {
--   "cenk1cenk2/schema-companion.nvim",
--   optional = false,
--   dependencies = {
--     { "nvim-lua/plenary.nvim" },
--     { "nvim-telescope/telescope.nvim" },
--     { "b0o/schemastore.nvim" },
--     { 'diogo464/kubernetes.nvim' }
--   },
--   config = function()
--     require("configs.schema-companion")
--   end,
-- }
