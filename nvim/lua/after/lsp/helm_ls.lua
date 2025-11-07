-- your LSP file: ./after/lsp/helm_ls.lua
return require("schema-companion").setup_client(
  require("schema-companion").adapters.helmls.setup({
    sources = {
      -- your sources for the language server
      require("schema-companion").sources.matchers.kubernetes.setup({ version = "master" }),
    },
  }),
  {
    --- your language server configuration
  }
)
