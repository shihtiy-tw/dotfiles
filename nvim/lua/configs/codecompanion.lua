local fmt = string.format

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
        ["file"] = {
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
            default = "deepseek-coder-v2:16b",
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
  prompt_library = {
    ["Generate a Semantics Commit Message"] = {
      strategy = "chat",
      description = "generate a Semantic Commit specification",
      prompts = {
        {
          role = "system",
          content =
          "You are an experienced developer with clear mindset of Conventional Commit specification and semantics commit message",
          "Below is a reference of Conventional Commit specification:",
          "# ----------------------------------------------------------",
          "# Header - type(scope): Brief description",
          "# ----------------------------------------------------------",
          "#    * feat             A new feature - SemVar PATCH",
          "#    * fix              A bug fix - SemVar MINOR",
          "#    * BREAKING CHANGE  Breaking API change - SemVar MAJOR",
          "#    * docs             Change to documentation only",
          "#    * style            Change to style (whitespace, etc.)",
          "#    * refactor         Change not related to a bug or feat",
          "#    * perf             Change that affects performance",
          "#    * test             Change that adds/modifies tests",
          "#    * build            Change to build system",
          "#    * ci               Change to CI pipeline/workflow",
          "#    * chore            General tooling/config/min refactor",
          "# ----------------------------------------------------------",
          "#   * Ex: docs: Update README with contributing instructions",
          "# ----------------------------------------------------------",
          "# ----------------------------------------------------------",
          "# Body - More detailed description, if necessary",
          "# ----------------------------------------------------------",
          "#   * Motivation behind changes, more detail into how",
          "# functionality might be affected, etc.",
          "# ----------------------------------------------------------",
          "#   * Ex: Adds a CONTRIBUTING.md with PR best practices,",
          "#         code style guide, and code of conduct for",
          "#         contributors.",
          "# ----------------------------------------------------------",
          "# ----------------------------------------------------------",
          "# Footer - Associated issues, PRs, etc.",
          "# ----------------------------------------------------------",
          "#   * Ex: Resolves Issue #207, see PR #15, etc.",
          "# ----------------------------------------------------------",
        },
        {
          role = "user",
          content = function()
            return fmt(
              [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

```diff
%s
```
]],
              vim.fn.system("git diff --no-ext-diff --staged")
            )
          end,
          opts = {
            contains_code = true,
          },
        }
      },
    }
  }
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
