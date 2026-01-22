return {
  'iwe-org/iwe.nvim',
  dependencies = {
    -- At least one picker recommended (any of these):
    'nvim-telescope/telescope.nvim',
    -- 'ibhagwan/fzf-lua',
    -- 'folke/snacks.nvim',
    -- 'echasnovski/mini.pick',
  },
  config = function()
    require('iwe').setup({
      -- All options are optional with sensible defaults
    })
  end
}
