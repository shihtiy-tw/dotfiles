-- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.command_history, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
vim.keymap.set('n', '<leader>fc', builtin.commands, {})
vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fC', builtin.colorscheme, {})

-- kustomize
vim.keymap.set("n", "<leader>Kb", "<cmd>lua require('kustomize').build()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>KK", "<cmd>lua require('kustomize').kinds()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>KL", "<cmd>lua require('kustomize').list_resources()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>Kp", "<cmd>lua require('kustomize').print_resources()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>Kv", "<cmd>lua require('kustomize').validate()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>Kd", "<cmd>lua require('kustomize').deprecations()<cr>", { noremap = true })


-- telescope for lsp
vim.keymap.set('n', '<leader>fgc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>flr', builtin.lsp_references, {})                -- Lists LSP references for the word under the cursor
vim.keymap.set('n', '<leader>fli', builtin.lsp_incoming_calls, {})            -- Lists LSP incoming calls for the word under the cursor
vim.keymap.set('n', '<leader>flo', builtin.lsp_outgoing_calls, {})            -- Lists LSP outgoing calls for the word under the cursor
vim.keymap.set('n', '<leader>fls', builtin.lsp_document_symbols, {})          -- Lists LSP document symbols in the current buffer
vim.keymap.set('n', '<leader>flw', builtin.lsp_workspace_symbols, {})         -- Lists LSP document symbols in the current workspace
vim.keymap.set('n', '<leader>flD', builtin.lsp_dynamic_workspace_symbols, {}) -- Dynamically Lists LSP for all workspace symbols
vim.keymap.set('n', '<leader>flm', builtin.lsp_implementations, {})           -- Goto the implementation of the word under the cursor if there's only one, otherwise show all options in Telescope
vim.keymap.set('n', '<leader>fld', builtin.lsp_definitions, {})               -- Goto the definition of the word under the cursor, if there's only one, otherwise show all options in Telescope
vim.keymap.set('n', '<leader>flt', builtin.lsp_type_definitions, {})          -- Goto the definition of the type of the word under the cursor, if there's only one, otherwise show all options in Telescope


-- telescope for git
vim.keymap.set('n', '<leader>fgc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>fgb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>fgs', builtin.git_status, {})

-- alternative file and other plugin
vim.keymap.set('n', '[e', '<C-^>', {})


vim.api.nvim_set_keymap("n", "<leader>ll", "<cmd>:Other<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ltn", "<cmd>:OtherTabNew<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>lp", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>lv", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>lc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true })

-- Context specific bindings
vim.api.nvim_set_keymap("n", "<leader>lt", "<cmd>:Other test<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ls", "<cmd>:Other scss<CR>", { noremap = true, silent = true })

-- oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- git fugitive
vim.keymap.set("n", "<leader>gg", ":Git ", { silent = true })
vim.keymap.set("n", "<leader>gs", ":Git<cr>", { silent = true })
vim.keymap.set("n", "<leader>ga", ":Git add %:p<cr><cr>", { silent = true })
vim.keymap.set("n", "<leader>gp", ":Git add -p %:p<cr><cr>", { silent = true })
vim.keymap.set("n", "<leader>gS", ":Git diff --staged %:p<cr><cr>", { silent = true })
vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<cr>", { silent = true })
vim.keymap.set("n", "<leader>ge", ":Gedit<cr>", { silent = true })
vim.keymap.set("n", "<leader>gw", ":Gwrite<cr>", { silent = true })
vim.keymap.set("n", "<leader>gc", ":Git commit<cr>", { silent = true })
vim.keymap.set("n", "<leader>gb", ":Gblame<cr>", { silent = true })
vim.keymap.set("n", "<leader>gl",
  ":Git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%ai%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all<cr>",
  { silent = true })

-- url-open
vim.keymap.set("n", "gx", "<esc>:URLOpenUnderCursor<cr>")

-- snippets
local ls = require("luasnip")

vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

-- schema companion
vim.keymap.set("n", "<leader>sy", function()
  return require("telescope").extensions.schema_companion.select_from_matching_schemas()
end, { desc = "Select from Matching Schema" })
vim.keymap.set("n", "<leader>sY", function()
  return require("telescope").extensions.schema_companion.select_schema()
end, { desc = "Select from Schema" })

-- hop
-- place this in one of your configuration file(s)
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = nil, current_line_only = false, multi_windows = true })
end, { remap = true })
vim.keymap.set('', 'F', function()
  hop.hint_char2({ direction = nil, current_line_only = false, multi_windows = true })
end, { remap = true })
vim.keymap.set('', 'fw', function()
  hop.hint_words({ direction = nil, current_line_only = false, hint_offset = -1, multi_windows = true })
end, { remap = true })
vim.keymap.set('', 'fp', function()
  hop.hint_patterns({ direction = nil, current_line_only = false, hint_offset = 1, multi_windows = true })
end, { remap = true })
vim.keymap.set('', 'fl', function()
  hop.hint_lines({ multi_windows = true })
end, { remap = true })

-- tree
-- https://github.com/nvim-tree/nvim-tree.lua/blob/cb57691536702ea479afd294657f6a589d0faae1/doc/nvim-tree-lua.txt#L2329

require("nvim-tree").setup {}
vim.api.nvim_set_keymap('n', '<F9>', '<cmd>NvimTreeFindFileToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<F9>', '<cmd>NvimTreeFindFileToggle<CR>', { noremap = true })

-- clear search result
vim.api.nvim_set_keymap('n', '<leader>m', '<cmd>noh<CR>', { noremap = true })
-- vim.api.nvim_set_keymap('i', '<leader>m', '<cmd>noh<CR>', { noremap = true })

-- Notion
vim.keymap.set("n", "<leader>no", function() require "notion".openMenu() end)


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

-- change input
-- vim.api.nvim_set_keymap('n', '<ESC>', '<c-space>', { noremap = true })

-- move in panels
vim.api.nvim_set_keymap('n', '<leader>h', '<c-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>j', '<c-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>k', '<c-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>l', '<c-w>l', { noremap = true })


-- Termianl
vim.keymap.set('t', '<leader><Esc>', '<C-\\><C-n>', { noremap = true })

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
    left       = '<S-left>',
    right      = '<S-right>',
    down       = '<S-down>',
    up         = '<S-up>',

    line_left  = '<S-left>',
    line_right = '<S-right>',
    line_down  = '<S-down>',
    line_up    = '<S-up>',
  }
})
