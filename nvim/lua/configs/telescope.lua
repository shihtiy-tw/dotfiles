local telescope = require('telescope')

telescope.setup {
  defaults = {
    mappings = {
      -- https://www.reddit.com/r/neovim/comments/xpaqwy/telescope_search_for_files_jump_to_the_tab_if_the/
      -- i = {
      --   ["<cr>"] = function(bufnr)
      --     require("telescope.actions.set").edit(bufnr, "tab drop")
      --   end
      -- },
      -- n = {
      --   ["<cr>"] = function(bufnr)
      --     require("telescope.actions.set").edit(bufnr, "tab drop")
      --   end
      -- }
    }
  },
  -- extensions = {
  --   -- fzf = {
  --   --   fuzzy = true,                   -- false will only do exact matching
  --   --   override_generic_sorter = true, -- override the generic sorter
  --   --   override_file_sorter = true,    -- override the file sorter
  --   --   case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
  --   --   -- the default case_mode is "smart_case"
  --   -- }
  -- }
}

-- telescope.load_extension('fzf')
telescope.load_extension('luasnip')
telescope.load_extension('notify')
telescope.load_extension("noice")
-- telescope.load_extension("terraform")
telescope.load_extension("terraform_doc")
