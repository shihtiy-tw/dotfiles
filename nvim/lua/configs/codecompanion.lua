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
    language = "English", -- Default is "English"
  },
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        -- MCP Tools
        make_tools = true,                    -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
        show_server_tools_in_chat = true,     -- Show individual tools in chat completion (when make_tools=true)
        add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
        show_result_in_chat = true,           -- Show tool results directly in chat buffer
        format_tool = nil,                    -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
        -- MCP Resources
        make_vars = true,                     -- Convert MCP resources to #variables for prompts
        -- MCP Prompts
        make_slash_commands = true,           -- Add MCP prompts as /slash commands
      }
    }
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
    agent = {
      adapter = "ollama"
    }
  },

  adapters = {
    openrouter = function()
      return require("codecompanion.adapters").extend("openai_compatible", {
        name = "openrouter",
        env = {
          url = "https://openrouter.ai/api",
          api_key = os.getenv("OPENROUTER_KEY"),
          chat_url = "/v1/chat/completions",
        },
        opts = {
          stream = false,
          can_reason = true
        },
        schema = {
          model = {
            default = "qwen/qwen3-30b-a3b:free",
            choices = { "moonshotai/kimi-k2:free" },
          },
        },
        handlers = {
          chat_output = function(self, data)
            local utils = require("codecompanion.utils.adapters")
            local output = {}

            if data and data ~= "" then
              local data_mod = utils.clean_streamed_data(data)
              local ok, json = pcall(vim.json.decode, data_mod, { luanil = { object = true } })

              if ok and json.choices and #json.choices > 0 then
                local choice = json.choices[1]
                local delta = (self.opts and self.opts.stream) and choice.delta or choice.message

                if delta then
                  output.role = nil
                  if delta.role then
                    output.role = delta.role
                  end
                  if self.opts.can_reason and delta.reasoning then
                    output.reasoning = delta.reasoning
                  end
                  if delta.content then
                    output.content = (output.content or "") .. delta.content
                  end
                  return {
                    status = "success",
                    output = output,
                  }
                end
              end
            end
          end,
        },
      })
    end,
    ollamadeepseekcoderv2 = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "ollamadeepseekcoderv2",
        schema = {
          model = {
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
    ollama = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "ollama",
        schema = {
          model = {
            -- https://ollama.com/library/llama3.2:3b
            --default = "deepseek-r1:1.5b",
            --default = "deepseek-coderv2:1.5b",
            default = "qwen2.5-coder:3b",
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
