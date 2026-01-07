require("avante").setup({
  ---@alias Provider "ollama" | "gemini"
  provider = "gemini-cli",                  -- Switch to gemini as default for better reasoning
  auto_suggestions_provider = "gemini-cli", -- Keep local for speed/cost

  -- MCP Prompt Logic
  system_prompt = function()
    local ok, hub = pcall(require, "mcphub")
    if ok then
      local instance = hub.get_hub_instance()
      return instance and instance:get_active_servers_prompt() or ""
    end
    return ""
  end,

  -- MCP Tools Logic
  custom_tools = function()
    local ok, mcp_avante = pcall(require, "mcphub.extensions.avante")
    if ok then
      return { mcp_avante.mcp_tool() }
    end
    return {}
  end,


  providers = {
    -- Gemini Configuration
    gemini = {
      model = "gemini-3-pro-review", -- or "gemini-1.5-pro" for deeper reasoning
      max_tokens = 4096,
      temperature = 0,
    },
    ollama = {
      endpoint = "http://localhost:11434",
      model = "qwen2.5-coder:7b", -- Recommended for local tool use over 3b
      disable_tools = false,      -- Must be false for MCP to work
      max_tokens = 32768,
      timeout = 30000,            -- Local models can be slow to start
    },
    -- Specialized reasoning provider (No tools)
    ollama_deepseek = {
      __inherited_from = "openai",
      endpoint = "http://localhost:11434/v1",
      api_key_name = "",
      model = "deepseek-r1:7b",
      disable_tools = true,
      max_tokens = 32768,
    },
  },


  acp_providers = {
    ["gemini-cli"] = {
      command = "gemini",
      args = { "--experimental-acp" },
      env = {
        NODE_NO_WARNINGS = "1",
        --    GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
      },
    },
    -- ["claude-code"] = {
    --   command = "npx",
    --   args = { "@zed-industries/claude-code-acp" },
    --   env = {
    --     NODE_NO_WARNINGS = "1",
    --     ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
    --   },
    -- },
    -- ["goose"] = {
    --   command = "goose",
    --   args = { "acp" },
    -- },
    -- ["codex"] = {
    --   command = "npx",
    --   args = { "@zed-industries/codex-acp" },
    --   env = {
    --     NODE_NO_WARNINGS = "1",
    --     OPENAI_API_KEY = os.getenv("OPENAI_API_KEY"),
    --   },
    -- },
  },

  -- Keep your existing window and behavior settings
  mode = "legacy",
  cursor_applying_provider = "gemini",
  behaviour = {
    enable_cursor_planning_mode = true,
  },
  windows = {
    edit = { border = "rounded" },
    ask = {
      floating = false,
      start_insert = true,
      border = "rounded",
    },
  },
})
