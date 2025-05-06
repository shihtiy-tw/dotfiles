require('mason-nvim-dap').setup({
  ensure_installed = { 'python', 'stylua', 'jq' },

  handlers = {}, -- Let dap handle
})

-- DAP Python setup
require('dap-python').setup('python3') -- Path to your Python executable

-- Custom launch configuration
table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'My custom launch configuration',
  program = '${file}',
  pythonPath = function()
    return '/usr/bin/python3'
  end,
})

-- DAP UI setup
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
