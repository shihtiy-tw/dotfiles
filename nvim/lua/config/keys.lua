-- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fc', builtin.commands, {})
vim.keymap.set('n', '<leader>fC', builtin.colorscheme, {})
vim.keymap.set('n', '<leader>fgc', builtin.git_commits	, {})
vim.keymap.set('n', '<leader>fgb', builtin.git_branches	, {})
vim.keymap.set('n', '<leader>fgs', builtin.git_status	, {})

-- tree
-- https://github.com/nvim-tree/nvim-tree.lua/blob/cb57691536702ea479afd294657f6a589d0faae1/doc/nvim-tree-lua.txt#L2329

require("nvim-tree").setup {}
vim.api.nvim_set_keymap('n', '<F9>', '<cmd>NvimTreeFindFileToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<F9>', '<cmd>NvimTreeFindFileToggle<CR>', { noremap = true })

-- move in panels
vim.api.nvim_set_keymap('n', '<leader>h', '<c-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>j', '<c-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>k', '<c-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>l', '<c-w>l', { noremap = true })

-- mini move
  -- `HJKL` for moving visual selection (overrides H, L, J in Visual mode)
  require('mini.move').setup({
    mappings = {
      left  = 'H',
      right = 'L',
      down  = 'J',
      up    = 'K',
    }
  })

  -- Shift + arrows
  require('mini.move').setup({
    mappings = {
      left  = '<S-left>',
      right = '<S-right>',
      down  = '<S-down>',
      up    = '<S-up>',

      line_left  = '<S-left>',
      line_right = '<S-right>',
      line_down  = '<S-down>',
      line_up    = '<S-up>',
    }
  })
