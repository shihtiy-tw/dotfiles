require("avante").setup({
  -- system_prompt as function ensures LLM always has latest MCP server state
  -- This is evaluated for every message, even in existing chats
  system_prompt = function()
    local hub = require("mcphub").get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ""
  end,
  -- Using function prevents requiring mcphub before it's loaded
  custom_tools = function()
    return {
      require("mcphub.extensions.avante").mcp_tool(),
    }
  end,
  -- add any opts here
  -- for example
  -- https://github.com/yetone/avante.nvim/issues/2048j
  mode = "legacy", -- solve cannnot apply change issue for local LLM
  -- mode = "agentic",
  provider = "ollama",
  auto_suggestions_provider = "ollama",
  providers = {
    -- bedrock = {
    --   model = "us.anthropic.claude-3-5-sonnet-20241022-v2:0",
    --   aws_profile = "default",
    --   aws_region = "us-east-1",
    -- },
    ollama = {
      endpoint = "http://localhost:11434",
      --model = "deepseek-r1:1.5b",
      -- model = "qwen2.5-coder:3b",
      model = "qwen3:4b",
      -- model = "deepseek-coder-v2:16b",
      -- important to set this to true if you are using a local server
      disable_tools = false,
      max_tokens = 32768,
    },
    ollama_deepseek = {
      __inherited_from = "openai",
      endpoint = "http://localhost:11434/v1",
      api_key_name = "",
      model = "deepseek-r1:1.5b",
      -- model = "qwen2.5-coder:3b",
      -- model = "deepseek-coder-v2:16b",
      -- important to set this to true if you are using a local server
      disable_tools = true,
      max_tokens = 32768,
    },
  },
  windows = {
    edit = { border = "rounded" },
    ask = {
      floating = false,    -- Open the 'AvanteAsk' prompt in a floating window
      start_insert = true, -- Start insert mode when opening the ask window
      border = "rounded",
    },
  },
  cursor_applying_provider = "ollama",
  behaviour = {
    enable_cursor_planning_mode = true,
  },
})
