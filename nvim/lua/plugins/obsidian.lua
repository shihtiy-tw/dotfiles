return {
  "obsidian-nvim/obsidian.nvim",
  -- https://www.reddit.com/r/neovim/comments/1n8sygk/obsidiannvim_error_error_executing_vimschedule/
  -- issue with 3.14 "table expected, got nil"
  version = "3.12", -- recommended, use latest release instead of latest commit
  -- lazy = true,
  -- ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    "BufReadPre " .. vim.fn.expand "~" .. "Brainiverse/Brainiverse/*/*.md",
    "BufNewFile " .. vim.fn.expand "~" .. "Brainiverse/Brainiverse/*/*.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "brainiverse",
          path = "~/Brainiverse/Brainiverse",
          overrides = {
            notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
            new_notes_location = "current_dir",
            templates = {
              folder = 'Toolkit/Templates',
            },
          },
        },
      },
      disable_frontmatter = false,
      legacy_commands = false,

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "Calendar/Planner/05Daily/",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d-%a",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, default tags to add to each new daily note created.
        default_tags = { "daily-notes" },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "/Toolkit/Templates/Templater/Planner/Daily_Note_Templater.md",
        -- Optional, if you want `Obsidian yesterday` to return the last work day or `Obsidian tomorrow` to return the next work day.
        workdays_only = false,
      },
      templates = {
        folder = "Toolkit/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function.
        -- Functions are called with obsidian.TemplateContext objects as their sole parameter.
        -- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#substitutions
        substitutions = {},
      },

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

      ui = {
        enable = true, -- set to false to disable all additional syntax features
      },

      -- Specify how to handle attachments.
      attachments = {
        -- The default folder to place images in via `:Obsidian paste_img`.
        -- If this is a relative path it will be interpreted as relative to the vault root.
        -- You can always override this per image by passing a full path to the command instead of just a filename.
        img_folder = "Toolkit/Attachments/General", -- This is the default

      },

      footer = {
        enabled = true,
        format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
        hl_group = "Comment",
        separator = string.rep("-", 80),
      },
    })
  end,
}
