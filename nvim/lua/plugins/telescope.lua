return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  -- or                              , branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    opt = true,
    event = "UIEnter",
    run = 'make'
  },
  {
    'benfowler/telescope-luasnip.nvim',
    opt = true,
    module = 'telescope._extensions.luasnip'
  },
  config = function()
    require('configs.telescope')
  end
}
