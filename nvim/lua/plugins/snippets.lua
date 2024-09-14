return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },

    -- TODO: make the cmp can work with lasnip

    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    event = "InsertEnter",
    lazy = false,
    config = function()
      require("configs.luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  },
}
