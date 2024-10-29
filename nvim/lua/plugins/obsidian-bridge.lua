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
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    "BufReadPre " .. vim.fn.expand "~" .. "/Brainiverse/*/*.md",
    "BufNewFile " .. vim.fn.expand "~" .. "/Brainiverse/*/*.md",
  },
  lazy = true
}
