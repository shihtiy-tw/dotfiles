return {
  "oflisback/obsidian-bridge.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("obsidian-bridge").setup({
      -- obsidian_server_address = "https://localhost:27124",
      obsidian_server_address = "http://localhost:27123",
      scroll_sync = true -- See "Sync of buffer scrolling" section below
    })
  end,
  event = {
    "BufReadPre *.md",
    "BufNewFile *.md",
  },
  lazy = true
}
