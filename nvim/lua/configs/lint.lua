local lint = require "lint"

lint.linters_by_ft = {
  go = { "golangcilint" },
  -- markdown = { "markdownlint-cli2" },
  -- markdown = (function(bufnr)
  --   return { "markdownlint-cli2" }
  -- end)(),
  python = { "pylint" },
  ruby = { "rubocop" },
  -- sh = { "shellcheck" },
  dockerfile = { "hadolint" },
  yaml = { "yamllint" },
  make = { "checkmake" },
  terraform = { "tflint" },
  -- java = { "checkstyle" }

}

-- https://github.com/doctorfree/nvim-lazyman/blob/bb4091c962e646c5eb00a50eca4a86a2d43bcb7c/lua/utils/linter.lua#L41

local markdownlint = lint.linters["markdownlint-cli2"]
markdownlint.args = {
  '--ignore-path',
  'Brainiverse/',
}

lint.linters.yamllint.args = {
  "--config-file",
  vim.env.HOME .. "/dotfiles/nvim/lua/configs/lint/yamllint.yaml",
  "--format=parsable",
  "-",
}

-- Set pylint to work in virtualenv
lint.linters.pylint.cmd = 'python'
lint.linters.pylint.args = { '-m', 'pylint', '-f', 'json' }


local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

require('mason-nvim-lint').setup({
  -- A list of linters to automatically install if they're not already installed. Example: { "eslint_d", "revive" }
  -- This setting has no relation with the `automatic_installation` setting.
  -- Names of linters should be taken from the mason's registry.
  ---@type string[]
  ensure_installed = {},
  -- Whether linters that are set up (via nvim-lint) should be automatically installed if they're not already installed.
  -- It tries to find the specified linters in the mason's registry to proceed with installation.
  -- This setting has no relation with the `ensure_installed` setting.
  ---@type boolean
  automatic_installation = true,

  -- Disables warning notifications about misconfigurations such as invalid linter entries and incorrect plugin load order.
  quiet_mode = false,
})

-- https://github.com/mfussenegger/nvim-lint/issues/553
local lint_var = true
local toggle_lint = function()
  if lint_var == true then
    lint_var = false
    vim.diagnostic.enable(false)
  else
    lint_var = true
    vim.diagnostic.enable()
  end
end
vim.keymap.set({ "n" }, "gL", toggle_lint, { noremap = true, desc = "Toggle linter" })
