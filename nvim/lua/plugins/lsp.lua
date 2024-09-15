-- FIX: why lua file use yaml lsp
return {
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true,
    config = function()
      require("mason").setup {}
    end,
  },
  "williamboman/mason-lspconfig.nvim",
  'mhartington/formatter.nvim',
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    lazy = false,
    config = function()
      require("lsp-zero").setup {}
    end,
  },
  -- TODO: setup auto complete for python
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    event = 'InsertEnter',
    lazy = false,
    priority = 100,
    config = function(_, opts)
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local cmp_keybind = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- ['<S-TAB>'] = cmp.mapping.select_prev_item(),
        -- ['<TAB>'] = cmp.mapping.select_next_item(),
        -- complete
        -- ['<TAB'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        -- cancel
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          -- local copilot_keys = vim.fn["copilot#Accept"]()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
            -- elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
            --   vim.api.nvim_feedkeys(copilot_keys, "i", true)
          else
            fallback()
          end
        end, { "i", "s" }),
        ['<A-,>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ['<ENTER>'] = cmp.mapping.confirm({
          select = true,
          behavior = cmp.ConfirmBehavior.Replace
        }),
        -- ['<C-s>'] = cmp.mapping.confirm({
        --   select = true,
        --   behavior = cmp.ConfirmBehavior.Replace
        -- }),
      }

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
            -- vim.snippet.expand(args.body)
          end,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip', option = { show_autosnippets = true } },
          },
          {
            { name = 'buffer' },
            { name = 'path' }
          }),

        mapping = cmp_keybind,
      }
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          {
            { name = 'path' }
          },
          {
            { name = 'cmdline' }
          }
        )
      })
    end
    -- config = function()
    --   local cmp = require('cmp')
    --
    --   cmp.setup({
    --     sources = {
    --       { name = 'nvim_lsp' },
    --     },
    --     mapping = cmp.mapping.preset.insert({
    --       ['<C-Space>'] = cmp.mapping.complete(),
    --       ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    --       ['<C-d>'] = cmp.mapping.scroll_docs(4),
    --     }),
    --     snippet = {
    --       expand = function(args)
    --         vim.snippet.expand(args.body)
    --       end,
    --     },
    --   })
    -- end
  },
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'cenk1cenk2/schema-companion.nvim' },
    },
    config = function()
      -- https://github.com/hyperter96/nvim/blob/94b6824cd57c13eec1467c10f9973f4e70ff0ff7/lua/plugins/extras/lang/yaml.lua#L69
      require("lspconfig").yamlls.setup(require("schema-companion").setup_client({
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
          new_config.settings.yaml.schemas =
              vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
        end,
        settings = {
          yaml = {
            format = {
              enable = true,
            },
            validate = true,
            completion = true,
            keyOrdering = false,
            schemaStore = {
              -- Must disable built-in schemaStore support to use
              -- schemas from SchemaStore.nvim plugin
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "",
            },
            -- schemaStore = {
            --   -- Must disable built-in schemaStore support to use
            --   -- schemas from SchemaStore.nvim plugin
            --   enable = true,
            --   -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            --   url = "https://www.schemastore.org/api/json/catalog.json",
            -- },
            schemas = require('schemastore').yaml.schemas {
              -- select subset from the JSON schema catalog
              extra = {
                {
                  description = 'Current Kubernetes Schemas',
                  fileMatch = "k8s-*.yaml",
                  name = 'Kubernetes',
                  url = require('kubernetes').yamlls_schema(),
                },
              },
              ignore = {
                "dotnet-tools.json",
                "dotnet Release Index manifest",
                "Crowdsec scenario config"
              }
              -- select = {
              --   'kustomization.yaml',
              --   'docker-compose.yml'
              -- },
            },
            -- schemas = {
            -- ["~/.config/nvim/schemas/protolint.json"] = ".protolint.{yml,yaml}",
            -- ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
            -- ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
            -- ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] =
            -- "azure-pipelines.yml",
            -- ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
            -- ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
            -- ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
            -- ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
            -- ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
            -- ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
            -- ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] =
            -- "*gitlab-ci*.{yml,yaml}",
            -- ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
            -- "*api*.{yml,yaml}",
            -- ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
            -- "*docker-compose*.{yml,yaml}",
            -- ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
            -- "*flow*.{yml,yaml}",
            -- },
          },
        },
      }))
    end,
    opts = {
      setup = {
        yamlls = function()
          -- Neovim < 0.10 does not have dynamic registration for formatting
          if vim.fn.has("nvim-0.10") == 0 then
            LazyVim.lsp.on_attach(function(client, _)
              client.server_capabilities.documentFormattingProvider = true
            end, "yamlls")
          end
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  }, {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  config = function()
    require "configs.mason-tool-installer"
  end,
}, {
  'rshkarin/mason-nvim-lint'
}

}


-- mason.nvim will make sure we have access to the language servers.
-- mason-lspconfig to configure the automatic setup of every language server we install.
