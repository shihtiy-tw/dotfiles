return {
  "sudo-tee/opencode.nvim",
  config = function()
    require("opencode").setup({
      keymap = {
        input_window = {
          ['<cr>'] = { 'submit_input_prompt', mode = { 'n' } }, -- Disable Enter key for submitting prompts
          -- Other keymaps not specified will keep their default bindings
        }
      }
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        -- 'markdown' is deliberately omitted: markview.nvim renders markdown
        -- buffers, and both plugins decorating the same buffer conflict.
        file_types = { 'opencode_output' },
        -- opencode output has no LaTeX to render, and leaving this on asks for
        -- a latex parser plus the utftex/latex2text tools we don't install.
        latex = { enabled = false },
      },
      ft = { 'opencode_output' },
    },
    -- Optional, for file mentions and commands completion, pick only one
    -- `version` is required for blink to fetch its prebuilt fuzzy-matcher
    -- binary; without it the Rust lib is never downloaded/built.
    { 'saghen/blink.cmp', version = '*' },
    -- 'hrsh7th/nvim-cmp',

    -- Optional, for file mentions picker, pick only one.
    -- telescope is already the picker used across this config (octo, octohub,
    -- iwe), so reuse it instead of pulling in snacks.nvim, which was never set
    -- up here and failed its own healthcheck.
    'nvim-telescope/telescope.nvim',
    -- 'folke/snacks.nvim',
    -- 'ibhagwan/fzf-lua',
    -- 'nvim_mini/mini.nvim',
  },
}
