return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        opt = true,
        event = "UIEnter",
        run = 'make'
      },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
      },
      {
        'benfowler/telescope-luasnip.nvim',
        opt = true,
        module = 'telescope._extensions.luasnip'
      },
      {
        "ANGkeith/telescope-terraform-doc.nvim",
        opt = true,
      },
      -- {
      --   "cappyzawa/telescope-terraform.nvim",
      --   opt = true,
      -- }
    },
    requires = {
    },
    config = function()
      require('configs.telescope')
    end
  }

}
