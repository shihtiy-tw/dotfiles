return {
  "allaman/kustomize.nvim",
  requires ={"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"},
  ft = "yaml",
  opts = { enable_key_mappings = false },
    config = function(opts)
      require('kustomize').setup({opts})
    end,
}
