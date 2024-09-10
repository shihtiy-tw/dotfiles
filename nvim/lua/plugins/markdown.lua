return {
  "tadmccorkle/markdown.nvim",
  ft = "markdown", -- or 'event = "VeryLazy"'
  config = function()
    require("markdown").setup({
      -- configuration here or empty for defaults
    })
  end,
  opts = {
    -- configuration here or empty for defaults
  },
}
