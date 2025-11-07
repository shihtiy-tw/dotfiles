return require("schema-companion").setup_client(
  require("schema-companion").adapters.yamlls.setup({
    matchers = {
    },
    sources = {
      require("schema-companion").sources.matchers.kubernetes.setup({ version = "master" }),
      require("schema-companion").sources.lsp.setup(),
      require("schema-companion").sources.schemas.setup({
        {
          name = "Kubernetes master",
          uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json",
        },
        {
          name = "Kubernetes v1.30",
          uri =
          "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.3-standalone-strict/_definitions.json",
        },
        {
          name = "Kubernetes Main",
          uri = require('kubernetes').yamlls_schema()
        },
        {
          name = "Protolint",
          uri = "~/.config/nvim/schemas/protolint.json",
        },
        {
          name = "eksctl",
          uri = "file://home/ubuntu/dotfiles/nvim/lua/configs/schema/eksctl-schema.json",
        },
        {
          name = "ecs",
          uri =
          "https://raw.githubusercontent.com/shihtiy-tw/amazon-ecs-intellisense-schema/refs/heads/mainline/src/model/schema/schema.json",
        },
      }),
    },
  }),
  {
    --- your yaml language server configuration
  }
)
