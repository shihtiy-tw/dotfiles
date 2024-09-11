return {
  "shihtiy-tw/schema-companion.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
  },
  config = function()
    log_level = vim.log.levels.WARN
    require("configs.schema-companion")
  end,
}

--
-- return {
--   "cenk1cenk2/schema-companion.nvim",
--   dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "neovim/nvim-lspconfig" },
--   ft = "yaml",
--   --opts = {
--   config = function()
--     require("configs.schema-companion")
--   end
-- }
