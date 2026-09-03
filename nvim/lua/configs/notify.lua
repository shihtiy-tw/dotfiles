local notify = require("notify")

notify.setup {
  background_colour = "#000000",
  max_width = 30,
  -- "wrapped-compact" indexes message[1] unguarded, so notifications with an
  -- empty body (e.g. from :checkhealth) crash the renderer. "wrapped-default"
  -- keeps the wrapping without that assumption.
  render = "wrapped-default"
}

vim.notify = notify
