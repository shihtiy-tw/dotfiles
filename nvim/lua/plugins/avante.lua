return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
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
        __inherited_from = "openai",
        endpoint = "http://localhost:11434/v1",
        api_key_name = "",
        --model = "deepseek-r1:1.5b",
        model = "qwen2.5-coder:3b",
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
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick",         -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua",              -- for file_selector provider fzf
    "stevearc/dressing.nvim",        -- for input provider dressing
    "folke/snacks.nvim",             -- for input provider snacks
    "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua",        -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
