-- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
local wk = require 'which-key'

-- Trouble
local trouble_mappings = {
  { '<leader>x', group = '[Trouble]' } }
wk.add(trouble_mappings)

-- Telescope
local builtin = require('telescope.builtin')
local telescope_mappings = {
  { '<leader>f', group = '[Telescope]' } }
wk.add(telescope_mappings)
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files in the current working directory" })
vim.keymap.set('n', '<leader>fG', builtin.live_grep,
  { desc = "Live grep (search) through files in the current working directory" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "List and search through open buffers" })
vim.keymap.set('n', '<leader>fh', builtin.command_history, { desc = "Search through command history" })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "List and search available keymaps" })
vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = "List and search available commands" })
vim.keymap.set('n', '<leader>fj', builtin.jumplist, { desc = "Show and search the jumplist" })
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = "List and search recently opened files" })
vim.keymap.set('n', '<leader>fC', builtin.colorscheme, { desc = "Browse and select colorschemes" })
vim.keymap.set('n', '<leader>fm', builtin.man_pages, { desc = "Lists manpage entries" })
vim.keymap.set('n', '<leader>fS', builtin.spell_suggest,
  { desc = "Lists spelling suggestions for the current word under the cursor" })
vim.keymap.set('n', '<leader>fs', builtin.grep_string,
  { desc = "Searches for the string under your cursor or selection in your current working directory " })

-- telescope for neoclip
vim.keymap.set("n", "<leader>C", "<cmd>Telescope neoclip<CR>", { desc = "Toggle neoclip for register" })
vim.keymap.set("n", "<leader>c", "<cmd>Telescope macroscope<CR>", { desc = "Toggle neoclip for register" })

-- telescope for lsp
local telescope_lsp_mappings = {
  { '<leader>fl', group = '[Telescope for LSP]' } }
wk.add(telescope_lsp_mappings)
vim.keymap.set('n', '<leader>fld', builtin.lsp_definitions,
  {
    desc =
    "Goto the definition of the word under the cursor, if there's only one, otherwise show all options in Telescope"
  })
vim.keymap.set('n', '<leader>fli', builtin.lsp_implementations,
  {
    desc =
    "Goto the implementation of the word under the cursor if there's only one, otherwise show all options in Telescope"
  })
vim.keymap.set('n', '<leader>flt', builtin.lsp_type_definitions,
  {
    desc =
    "Goto the definition of the type of the word under the cursor, if there's only one, otherwise show all options in Telescope"
  })
vim.keymap.set('n', '<leader>flr', builtin.lsp_references,
  { desc = "Lists LSP references for the word under the cursor" })
vim.keymap.set('n', '<leader>flI', builtin.lsp_incoming_calls,
  { desc = "Lists LSP incoming calls for the word under the cursor" })
vim.keymap.set('n', '<leader>flO', builtin.lsp_outgoing_calls,
  { desc = "Lists LSP outgoing calls for the word under the cursor" })
vim.keymap.set('n', '<leader>fls', builtin.lsp_document_symbols,
  { desc = "Lists LSP document symbols in the current buffer" })
vim.keymap.set('n', '<leader>flw', builtin.lsp_workspace_symbols,
  { desc = "Lists LSP document symbols in the current workspace" })
vim.keymap.set('n', '<leader>flD', builtin.lsp_dynamic_workspace_symbols,
  { desc = "Dynamically Lists LSP for all workspace symbols" })

-- telescope for git
local telescope_git_mappings = {
  { '<leader>fg', group = '[Telescope for Git]' } }
wk.add(telescope_git_mappings)
vim.keymap.set('n', '<leader>fgc', builtin.git_commits, { desc = "telecsope for git commit" })
vim.keymap.set('n', '<leader>fgb', builtin.git_branches, { desc = "telecsope for git branches" })
vim.keymap.set('n', '<leader>fgs', builtin.git_status, { desc = "telescope for git status" })

-- alternative file and other plugin
vim.keymap.set('n', '[e', '<C-^>', { desc = "previous alternative file" })

-- kustomize
local kustomize_mappings = {
  { '<leader>Km', group = '[kustomize]' } }
wk.add(kustomize_mappings)
vim.keymap.set("n", "<leader>Kmb", "<cmd>lua require('kustomize').build()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>KmK", "<cmd>lua require('kustomize').kinds()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>KmL", "<cmd>lua require('kustomize').list_resources()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>Kmp", "<cmd>lua require('kustomize').print_resources()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>Kmv", "<cmd>lua require('kustomize').validate()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>Kmd", "<cmd>lua require('kustomize').deprecations()<cr>", { noremap = true })

-- aerial
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial for outline window." })

-- Obsidian
-- Open a note in Obsidian app
local obsidian_mappings = {
  { '<leader>o', group = '[Obsidian]' } }
wk.add(obsidian_mappings)
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "Open current note in Obsidian" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Create a new note" })
vim.keymap.set("n", "<leader>of", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick switch to another note" })
vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianFollowLink<CR>", { desc = "Follow link under cursor" })
vim.keymap.set("n", "<leader>oB", "<cmd>ObsidianBacklinks<CR>", { desc = "List backlinks to current note" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTags<CR>", { desc = "Search tags" })
vim.keymap.set("n", "<leader>od", "<cmd>ObsidianToday<CR>", { desc = "Open/create today's note" })
vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<CR>", { desc = "Open/create yesterday's note" })
vim.keymap.set("n", "<leader>om", "<cmd>ObsidianTomorrow<CR>", { desc = "Open/create tomorrow's note" })
vim.keymap.set("n", "<leader>oc", "<cmd>ObsidianDailies<CR>", { desc = "List daily notes" })
vim.keymap.set("n", "<leader>oi", "<cmd>ObsidianTemplate<CR>", { desc = "Insert template" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search notes" })
vim.keymap.set("v", "<leader>ol", "<cmd>ObsidianLink<CR>", { desc = "Link selected text to a note" })
vim.keymap.set("v", "<leader>on", "<cmd>ObsidianLinkNew<CR>", { desc = "Create new note and link selected text" })
vim.keymap.set("n", "<leader>ok", "<cmd>ObsidianLinks<CR>", { desc = "List all links in current buffer" })
vim.keymap.set("v", "<leader>oe", "<cmd>ObsidianExtractNote<CR>", { desc = "Extract selected text to a new note" })
vim.keymap.set("n", "<leader>ow", "<cmd>ObsidianWorkspace<CR>", { desc = "Switch workspace" })
vim.keymap.set("n", "<leader>op", "<cmd>ObsidianPasteImg<CR>", { desc = "Paste image from clipboard" })
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<CR>", { desc = "Rename current note or link under cursor" })
vim.keymap.set("n", "<leader>ox", "<cmd>ObsidianToggleCheckbox<CR>", { desc = "Toggle checkbox" })
vim.keymap.set("n", "<leader>oT", "<cmd>ObsidianNewFromTemplate<CR>", { desc = "Create new note from template" })
vim.keymap.set("n", "<leader>oa", "<cmd>ObsidianTOC<CR>", { desc = "Load table of contents" })

vim.keymap.set("n", "<leader>obd", "<cmd>ObsidianBridgeDailyNote<CR>", { desc = "Open or create daily note" })
vim.keymap.set("n", "<leader>obg", "<cmd>ObsidianBridgeOpenGraph<CR>", { desc = "Open graph view in Obsidian" })
vim.keymap.set("n", "<leader>obv", "<cmd>ObsidianBridgeOpenVaultMenu<CR>",
  { desc = "Open Obsidian vauolt selection dialog" })
vim.keymap.set("n", "<leader>obc", "<cmd>ObsidianBridgeTelescopeCommand<CR>",
  { desc = "List and execute oObsidian commands" })
vim.keymap.set("n", "<leader>obo", "<cmd>ObsidianBridgeOn<CR>", { desc = "Activate Obsidian Bridge plugin" })
vim.keymap.set("n", "<leader>obf", "<cmd>ObsidianBridgeOff<CR>", { desc = "Deactivate Obsidian Bridge plugin" })
vim.keymap.set("n", "<leader>obt", "<cmd>ObsidianBridgeToggle<CR>", { desc = "Toggle Obsidian Bridge plugin" })

-- inc-rename
local rename_mappings = {
  { '<leader>r', group = '[Rename]' } }
wk.add(rename_mappings)
vim.keymap.set("n", "<leader>rn", ":IncRename ")

-- autosave
vim.api.nvim_set_keymap("n", "<leader>n", ":ASToggle<CR>", { desc = "Toggle autosave" })

local other_mappings = {
  { '<leader>L', group = '[Other]' } }
wk.add(other_mappings)
vim.api.nvim_set_keymap("n", "<leader>Ll", "<cmd>:Other<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>Ltn", "<cmd>:OtherTabNew<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>Lp", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>Lv", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>Lc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true })

-- Context specific bindings
vim.api.nvim_set_keymap("n", "<leader>Lt", "<cmd>:Other test<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>Ls", "<cmd>:Other scss<CR>", { noremap = true, silent = true })

-- oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- nvim-ufo
-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "Open all fold" })
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "Close all fold" })

-- git fugitive
local git_mappings = {
  { '<leader>g', group = '[Git fugitive]' } }
wk.add(git_mappings)
vim.keymap.set("n", "<leader>gg", ":Git ", { silent = true })
vim.keymap.set("n", "<leader>gs", ":Git<cr>", { silent = true })
vim.keymap.set("n", "<leader>ga", ":Git add %:p<cr><cr>", { silent = true })
vim.keymap.set("n", "<leader>gA", ":Git add -p %:p<cr><cr>", { silent = true })
vim.keymap.set("n", "<leader>gr", ":Git restore %:p<cr><cr>", { silent = true })
vim.keymap.set("n", "<leader>gR", ":Git restore -p %:p<cr><cr>", { silent = true })
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
local schema_companion_mappings = {
  { '<leader>s', group = '[Schema Companion]' } }
wk.add(schema_companion_mappings)
vim.keymap.set("n", "<leader>sy", function()
  return require("telescope").extensions.schema_companion.select_from_matching_schemas()
end, { desc = "Select from Matching Schema" })
vim.keymap.set("n", "<leader>sY", function()
  return require("telescope").extensions.schema_companion.select_schema()
end, { desc = "Select from Schema" })

-- hop (easymotion)
-- place this in one of your configuration file(s)
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = nil, current_line_only = false, multi_windows = true })
end, { remap = true, desc = "Hop to any character in current buffer (multi-window)" })

vim.keymap.set('', 'F', function()
  hop.hint_char2({ direction = nil, current_line_only = false, multi_windows = true })
end, { remap = true, desc = "Hop to any bigram in current buffer (multi-window)" })

vim.keymap.set('', 'fw', function()
  hop.hint_words({ direction = nil, current_line_only = false, hint_offset = -1, multi_windows = true })
end, { remap = true, desc = "Hop to any word in current buffer (multi-window)" })

vim.keymap.set('', 'fp', function()
  hop.hint_patterns({ direction = nil, current_line_only = false, hint_offset = 1, multi_windows = true })
end, { remap = true, desc = "Hop to pattern matches in current buffer (multi-window)" })

vim.keymap.set('', 'fl', function()
  hop.hint_lines({ multi_windows = true })
end, { remap = true, desc = "Hop to any line in current buffer (multi-window)" })

-- tree
-- https://github.com/nvim-tree/nvim-tree.lua/blob/cb57691536702ea479afd294657f6a589d0faae1/doc/nvim-tree-lua.txt#L2329

require("nvim-tree").setup {}
vim.api.nvim_set_keymap('n', '<F9>', '<cmd>NvimTreeFindFileToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<F9>', '<cmd>NvimTreeFindFileToggle<CR>', { noremap = true })

-- clear search result
vim.api.nvim_set_keymap('n', '<leader>m', '<cmd>noh<CR>', { noremap = true })
-- vim.api.nvim_set_keymap('i', '<leader>m', '<cmd>noh<CR>', { noremap = true })

-- Notion
local notion_mappings = {
  { '<leader>n', group = '[Notion]' } }
wk.add(notion_mappings)
vim.keymap.set("n", "<leader>no", function() require "notion".openMenu() end, { desc = "Open Notion" })


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

vim.keymap.set("n", "<leader>A", function() harpoon:list():add() end, { desc = "Add file to harpoon." })
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

-- Linter and Formatter
-- vim.keymap.set({ "n" }, "gL", toggle_lint, { noremap = true, desc = "Toggle linter" })
-- vim.keymap.set({ "n" }, "gM", toggle_formatter, { noremap = true, desc = "Toggle formatter" })

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
