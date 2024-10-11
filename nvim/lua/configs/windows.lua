-- window plugin
require('nvim-window').setup({
  -- The characters available for hinting windows.
  chars = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
    'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
  },

  -- A group to use for overwriting the Normal highlight group in the floating
  -- window. This can be used to change the background color.
  normal_hl = 'Normal',

  -- The highlight group to apply to the line that contains the hint characters.
  -- This is used to make them stand out more.
  hint_hl = 'Bold',

  -- The border style to use for the floating window.
  border = 'single',

  -- How the hints should be rendered. The possible values are:
  --
  -- - "float" (default): renders the hints using floating windows
  -- - "status": renders the hints to a string and calls `redrawstatus`,
  --   allowing you to show the hints in a status or winbar line
  render = 'float',
})

-- Resizes
-- https://www.reddit.com/r/neovim/comments/1ciobdk/comment/l2dnu4m/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
vim.api.nvim_create_user_command("Vr", function(opts)
  local usage = "Usage: [VirticalResize] :Vr {number (%)}"
  if not opts.args or not string.len(opts.args) == 2 then
    print(usage)
    return
  end
  vim.cmd(":vertical resize " .. vim.opt.columns:get() * (opts.args / 100.0))
end, { nargs = "*" })

vim.api.nvim_create_user_command("Hr", function(opts)
  local usage = "Usage: [HorizontalResize] :Hr {number (%)}"
  if not opts.args or not string.len(opts.args) == 2 then
    print(usage)
    return
  end
  vim.cmd(
    ":resize "
    .. (
      (vim.opt.lines:get() - vim.opt.cmdheight:get())
      * (opts.args / 100.0)
    )
  )
end, { nargs = "*" })
