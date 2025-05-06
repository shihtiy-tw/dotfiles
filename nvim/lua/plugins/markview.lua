return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- Recommended
  -- ft = "markdown" -- If you decide to lazy-load anyway

  opts = {
    -- Initial plugin state,
    -- true = show preview
    -- falss = don't show preview
    preview = {
      enable = false
    },
  },

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  }
}
