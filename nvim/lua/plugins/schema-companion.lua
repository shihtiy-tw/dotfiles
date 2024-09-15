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
    require("configs.schema-companion")
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
