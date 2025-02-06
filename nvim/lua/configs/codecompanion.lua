require("codecompanion").setup({
  display = {
    diff = {
      provider = "mini_diff",
    },
    action_palette = {
      provider = "telescope"
    },
  },
  opts = {
    log_level = "DEBUG",
    language = "English" -- Default is "English"
  },
  strategies = {
    chat = {
      adapter = "ollama",
      -- https://github.com/olimorris/codecompanion.nvim/pull/406
      slash_commands = {
        ["buffer"] = {
          opts = {
            provider = "telescope", --you need that part
          },
        },
      },
    },
    inline = {
      adapter = "ollama",
    },
    -- agent = {
    --   adapter = "ollama"
    -- }
  },

  adapters = {
    ollama = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "ollama", -- Give this adapter a different name to differentiate it from the default ollama adapter
        schema = {
          model = {
            -- https://ollama.com/library/llama3.2:3b
            -- default = "llama3.2:1b",
            default = "deepseek-r1:8b",
          },
          num_ctx = {
            default = 16384,
          },
          num_predict = {
            default = -1,
          },
        },
        env = {
          url = "http://127.0.0.1:11434",
        },
        headers = {
          ["Content-Type"] = "application/json",
        },
        parameters = {
          sync = true,
        },
      })
    end,
  },
})

local M = require("lualine.component"):extend()

M.processing = false
M.spinner_index = 1

local spinner_symbols = {
  "⠋",
  "⠙",
  "⠹",
  "⠸",
  "⠼",
  "⠴",
  "⠦",
  "⠧",
  "⠇",
  "⠏",
}
local spinner_symbols_len = 10

-- Initializer
function M:init(options)
  M.super.init(self, options)

  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      if request.match == "CodeCompanionRequestStarted" then
        self.processing = true
      elseif request.match == "CodeCompanionRequestFinished" then
        self.processing = false
      end
    end,
  })
end

-- Function that runs every time statusline is updated
function M:update_status()
  if self.processing then
    self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
    return spinner_symbols[self.spinner_index]
  else
    return nil
  end
end

return M
