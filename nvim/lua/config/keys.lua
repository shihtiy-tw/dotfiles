-- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fc', builtin.commands, {})
vim.keymap.set('n', '<leader>fC', builtin.colorscheme, {})

-- tree
-- https://github.com/nvim-tree/nvim-tree.lua/blob/cb57691536702ea479afd294657f6a589d0faae1/doc/nvim-tree-lua.txt#L2329

require("nvim-tree").setup {}
vim.api.nvim_set_keymap('n', '<F9>', '<cmd>NvimTreeFindFileToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<F9>', '<cmd>NvimTreeFindFileToggle<CR>', { noremap = true })

