-- In your lazy.nvim plugin definitions
return {
  "cenk1cenk2/schema-companion.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "b0o/schemastore.nvim" },
    { 'diogo464/kubernetes.nvim' }
  },
  config = function()
    -- This is the main setup call. It initializes the plugin.
    require("schema-companion").setup({
      -- You can add global settings here
      -- https://github.com/astephanh/test-yamlls/blob/main/config/nvim/lua/plugins/schema-companion.lua
      log_level = vim.log.levels.DEBUG,
      enable_telescope = true, -- if you want the telescope extension
    })
  end,
}
