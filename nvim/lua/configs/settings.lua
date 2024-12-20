local global = vim.g
local o = vim.opt
vim.g.os = vim.loop.os_uname().sysname

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- auto saving
-- Define a function to check the buffer type and write the buffer if allowed
-- local function auto_write_buffer()
--   local buffer_type = vim.bo.buftype
--
--   -- Check if the buffer type is empty or 'acwrite'
--   if buffer_type == '' or buffer_type == 'acwrite' then
--     -- Write the buffer silently
--     vim.cmd('silent write')
--   end
-- end

-- Set up an autocmd to call the auto_write_buffer function when leaving the buffer
-- vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
--   callback = auto_write_buffer,
-- })

-- Editor options
-- https://dev.to/slydragonn/ultimate-neovim-setup-guide-lazynvim-plugin-manager-23b7

o.number = true             -- Print the line number in front of each line
o.relativenumber = false    -- Show the line number relative to the line with the cursor in front of each line.
o.clipboard = "unnamedplus" -- uses the clipboard register for all operations except yank.
o.syntax = "on"             -- When this option is set, the syntax with this name is loaded.
o.autoindent = true         -- Copy indent from current line when starting a new line.
o.cursorline = true         -- Highlight the screen line of the cursor with CursorLine.
o.expandtab = true          -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
o.shiftwidth = 2            -- Number of spaces to use for each step of (auto)indent.
o.tabstop = 2               -- Number of spaces that a <Tab> in the file counts for.
o.encoding = "UTF-8"        -- Sets the character encoding used inside Vim.
o.ruler = true              -- Show the line and column number of the cursor position, separated by a comma.
o.mouse = "a"               -- Enable the use of the mouse. "a" you can use on all modes
o.title = true              -- When on, the title of the window will be set to the value of 'titlestring'
o.hidden = true             -- When on a buffer becomes hidden when it is |abandon|ed
o.ttimeoutlen = 0           -- The time in milliseconds that is waited for a key code or mapped key sequence to complete.
o.wildmenu = true           -- When 'wildmenu' is on, command-line completion operates in an enhanced mode.
o.showcmd = true            -- Show (partial) command in the last line of the screen. Set this option off if your terminal is slow.
o.showmatch = true          -- When a bracket is inserted, briefly jump to the matching one.
o.inccommand =
"split"                     -- When nonempty, shows the effects of :substitute, :smagic, :snomagic and user commands with the :command-preview flag as you type.
o.splitright = true
o.splitbelow = true         -- When on, splitting a window will put the new window below the current one
o.termguicolors = true
o.conceallevel = 2
o.swapfile = false

-- set list
-- set listchars=tab:\\t
-- vim.o.listchars = 'space:_,tab:>~'
-- vim.o.listchars = 'tab:^I'
vim.opt.list = true


-- folding
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true



-- tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- auto-reload files when modified externally
-- https://unix.stackexchange.com/a/383044
-- Triger `autoread` when files changes on disk
-- https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
-- https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode

-- https://stackoverflow.com/questions/41416072/change-the-hold-time-of-the-cursor
vim.o.updatetime = 5000

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  pattern = '*',
  command = "if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif",
})

-- Notification after file change
-- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
vim.api.nvim_create_autocmd({ 'FileChangedShellPost' }, {
  pattern = '*',
  command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})

-- --- LSP
-- vim.lsp.set_log_level("INFO")
