local lint = require "lint"

lint.linters_by_ft = {
  go = { "golangcilint" },
  markdown = { "markdownlint-cli2" },
  -- markdown = (function(bufnr)
  --   return { "markdownlint-cli2" }
  -- end)(),
  python = { "pylint" },
  ruby = { "rubocop" },
  terraform = { "tflint" },
  -- sh = { "shellcheck" },
  dockerfile = { "hadolint" },
  yaml = { "yamllint" },
  make = { "checkmake" },
  -- java = { "checkstyle" }

}


local markdownlint = require('lint').linters["markdownlint-cli2"]
markdownlint.args = {
  '--ignore-path',
  'Brainiverse/',
}


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
