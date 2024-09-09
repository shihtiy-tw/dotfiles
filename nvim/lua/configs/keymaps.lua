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

-- url-open
vim.keymap.set("n", "gx", "<esc>:URLOpenUnderCursor<cr>")

-- hop
-- place this in one of your configuration file(s)
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = nil, current_line_only = false, multi_windows = true })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char2({ direction = nil, current_line_only = false, multi_windows = true})
end, {remap=true})
vim.keymap.set('', 'fw', function()
  hop.hint_words({ direction = nil, current_line_only = false, hint_offset = -1, multi_windows = true })
end, {remap=true})
vim.keymap.set('', 'fp', function()
  hop.hint_patterns({ direction = nil, current_line_only = false, hint_offset = 1, multi_windows = true })
end, {remap=true})
vim.keymap.set('', 'fl', function() hop.hint_lines({ multi_windows = true })
end, {remap=true})

-- tree
-- https://github.com/nvim-tree/nvim-tree.lua/blob/cb57691536702ea479afd294657f6a589d0faae1/doc/nvim-tree-lua.txt#L2329

require("nvim-tree").setup {}
vim.api.nvim_set_keymap('n', '<F9>', '<cmd>NvimTreeFindFileToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<F9>', '<cmd>NvimTreeFindFileToggle<CR>', { noremap = true })

-- clear search result
vim.api.nvim_set_keymap('n', '<leader>m', '<cmd>noh<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<leader>m', '<cmd>noh<CR>', { noremap = true })

-- Notion
vim.keymap.set("n", "<leader>no", function () require"notion".openMenu() end)


-- TODO
vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>TodoTelescope<CR>', { noremap = true })

-- Lazy
vim.api.nvim_set_keymap('n', '<leader>z', '<cmd>Lazy<CR>', { noremap = true })

-- Mason
vim.api.nvim_set_keymap('n', '<leader>M', '<cmd>Mason<CR>', { noremap = true })

-- tabs
vim.api.nvim_set_keymap('n', '<TAB>', 'gt', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-TAB>', 'gT', { noremap = true })
--vim.api.nvim_set_keymap('n', '<leader>t', 't :tabedit', { noremap = true })

-- move in panels
vim.api.nvim_set_keymap('n', '<leader>h', '<c-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>j', '<c-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>k', '<c-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>l', '<c-w>l', { noremap = true })


-- harpoon
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
--vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

harpoon:setup({})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })

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
