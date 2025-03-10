return {
  "williamboman/mason.nvim",
  "mfussenegger/nvim-dap",
  "jay-babu/mason-nvim-dap.nvim",
  "nvim-telescope/telescope-dap.nvim",
  'theHamsta/nvim-dap-virtual-text',

  "rcarriga/nvim-dap-ui",
  dependencies = { "nvim-neotest/nvim-nio" },

  'mfussenegger/nvim-dap-python',


  config = function()
    require('configs.dap')
  end

}
