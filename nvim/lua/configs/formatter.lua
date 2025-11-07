local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    lua = { "luaformatter" },
    -- Conform will run multiple formatters sequentially
    python = { "ruff_format" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    -- rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
    -- this will overrite the tag in obsidian to a header
    -- markdown = { "markdownlint-cli2", stop_after_first = true },
    -- markdown = function(bufnr)
    --   return { "markdownlint-cli2", stop_after_first = true }
    -- end,
    sh = { "shellharden" },
    yaml = { "yamlfix", "prettierd", "prettier", stop_after_first = true },
    -- java = { "google-java-format", stop_after_first = true },
    terraform = { "terraform_fmt" },
    tf = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },

  },
  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_format = "fallback",
  -- },
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 5000, lsp_format = "fallback" }
  end,
})

-- These can also be set directly
conform.formatters.yamlfix = {
  env = {
    YAMLFIX_SEQUENCE_STYLE = "block_style",
    YAMLFIX_QUOTE_BASIC_VALUES = "false",
    YAMLFIX_preserve_quotes = "true"
  },
}

conform.formatters["markdownlint-cli2"] = {
  prepend_args = {
    "--config",
    vim.env.HOME .. "/dotfiles/nvim/lua/configs/formatter/markdownlint-cli2.toml",
  },
}

-- https://github.com/angelofallars/dotfiles/blob/a0d2d199c5b0fe22f3b013473d830c291e7148db/nvim/lua/plugins/config/conform.lua#L42
-- https://stackoverflow.com/questions/34573200/errors-when-including-hyphens-in-table-variables
-- prepend_args = {
--   conform.formatters.["markdownlint-cli2"] = {
-- "--config",
-- vim.env.HOME .. "/.config/nvim/lua/plugins/config/formatter/.markdownlint-cli2.jsonc",
-- },
-- }

-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

local formatter_var = true
local toggle_formatter = function()
  if formatter_var == true then
    formatter_var = false
    vim.diagnostic.enable(false)
    vim.api.nvim_exec("FormatDisable", false)
  else
    formatter_var = true
    vim.api.nvim_exec("FormatEnable", false)
  end
end

vim.keymap.set({ "n" }, "gM", toggle_formatter, { noremap = true, desc = "Toggle formatter" })

require("mason-conform.auto_install")()
