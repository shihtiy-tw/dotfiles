return {
  "obsidian-nvim/obsidian.nvim",
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
    disable_frontmatter = true,

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

    -- Specify how to handle attachments.
    attachments = {
      -- The default folder to place images in via `:Obsidian paste_img`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      -- You can always override this per image by passing a full path to the command instead of just a filename.
      img_folder = "Atlas/Utilities/Attachments/General/imgs", -- This is the default

      -- A function that determines default name or prefix when pasting images via `:Obsidian paste_img`.
      ---@return string
      img_name_func = function()
        -- Prefix image names with timestamp.
        return string.format("Pasted image %s", os.date "%Y%m%d%H%M%S")
      end,

      -- A function that determines the text to insert in the note when pasting an image.
      -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
      -- This is the default implementation.
      ---@param client obsidian.Client
      ---@param path obsidian.Path the absolute path to the image file
      ---@return string
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![%s](%s)", path.name, path)
      end,
    },

    -- See https://github.com/obsidian-nvim/obsidian.nvim/wiki/Notes-on-configuration#statusline-component
    statusline = {
      enabled = true,
      format = "{{properties}} properties {{backlinks}} backlinks {{words}} words {{chars}} chars",
    },
  },
}
