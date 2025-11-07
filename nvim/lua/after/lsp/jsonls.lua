-- your LSP file: ./after/lsp/jsonls.lua
return require("schema-companion").setup_client(
  require("schema-companion").adapters.jsonls.setup({
    sources = {
      require("schema-companion").sources.lsp.setup(),
      require("schema-companion").sources.none.setup(),
    },
  }),
  {
    --- your language server configuration
  }
)
