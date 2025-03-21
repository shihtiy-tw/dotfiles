return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  -- ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    "BufReadPre " .. vim.fn.expand "~" .. "/Brainiverse/*/*.md",
    "BufNewFile " .. vim.fn.expand "~" .. "/Brainiverse/*/*.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "brainiverse",
        path = "~/Brainiverse/Brainiverse",
        overrides = {
          notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
          new_notes_location = "current_dir",
          templates = {
            folder = 'Atlas/Utilities/Templates',
          },
        },
      },
      {
        name = "no-vault",
        path = function()
          -- alternatively use the CWD:
          -- return assert(vim.fn.getcwd())
          return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        end,
        overrides = {
          notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
          new_notes_location = "current_dir",
          -- templates = {
          --   folder = 'Atlas/Utilities/Templates',
          -- },
          templates = {
            folder = (function()
              local template_folder
              if vim.g.os == "Darwin" and (string.find(vim.api.nvim_buf_get_name(0), "Brainiverse") or string.find(vim.api.nvim_buf_get_name(0), "Amazon")) then
                template_folder = "Atlas/Utilities/Templates"
              else
                template_folder = vim.NIL
              end
              return template_folder
            end)(),
          },
        },
      },
    },
    disable_frontmatter = false,

    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
      name = "telescope.nvim",
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      note_mappings = {
        -- Create a new note from your query.
        new = "<C-X>",
        -- Insert a link to the selected note.
        insert_link = "<C-I>",
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = "<C-n>",
        -- Insert a tag at the current location.
        insert_tag = "<C-s>",
      },
    },

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart({ "open", url }) -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      -- vim.ui.open(url) -- need Neovim 0.10.0+
    end,

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
    -- file it will be ignored but you can customize this behavior here.
    -- NOTE: this function hasn't be released yet
    -- https://github.com/aquilesg/obsidian.nvim/commit/55aed056596f66af3d4d1852c7769bb600f6ce37
    ---@param img string
    follow_img_func = function(img)
      vim.fn.jobstart { "qlmanage", "-p", img } -- Mac OS quick look preview
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
    end,
    -- UI will be placed by render-markdown
    ui = {
      enable = false, -- set to false to disable all additional syntax features
    }
  },
}
