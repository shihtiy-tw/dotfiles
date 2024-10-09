local telescope = require('telescope')

telescope.load_extension('fzf')
telescope.load_extension('luasnip')
telescope.load_extension('notify')
telescope.load_extension("noice")

telescope.setup {
  defaults = {
    mappings = {
      -- https://www.reddit.com/r/neovim/comments/xpaqwy/telescope_search_for_files_jump_to_the_tab_if_the/
      i = {
        ["<cr>"] = function(bufnr)
          require("telescope.actions.set").edit(bufnr, "tab drop")
        end
      },
      n = {
        ["<cr>"] = function(bufnr)
          require("telescope.actions.set").edit(bufnr, "tab drop")
        end
      }
    }
  }
}
