return {
  'nvim-java/nvim-java',
  enable = false,
  -- config = function()
  --   require('java').setup()
  -- end

  -- This plugin does not work with mason 2.0 at the moment.
  -- FIX: pending for mason 2.0 support
  -- https://github.com/nvim-java/nvim-java/issues/384
  -- xxx/.config/nvim/lua/plugins/dap.lua:17: attempt to call method 'get_install_path' (a nil value)

}
