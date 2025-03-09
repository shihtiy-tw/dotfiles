local notify = require("notify")

notify.setup {
  background_colour = "#000000",
  max_width = 30,
  render = "wrapped-compact"
}

vim.notify = notify
