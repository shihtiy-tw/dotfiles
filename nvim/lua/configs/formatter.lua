require("conform").setup({
  formatters_by_ft = {
    lua = { "luaformatter" },
    -- Conform will run multiple formatters sequentially
    -- python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    -- rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
    markdown = { "markdownlint-cli2", stop_after_first = true },
    sh = { "shellharden" },
    yaml = { "prettierd", "prettier", stop_after_first = true },

  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

require("mason-conform.auto_install")()
