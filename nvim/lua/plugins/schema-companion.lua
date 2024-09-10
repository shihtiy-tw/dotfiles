return {
  "shihtiy-tw/schema-companion.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
  },
  config = function()
    require("schema-companion").setup({
      -- if you have telescope you can register the extension
      enable_telescope = true,
      matchers = {
        -- FIX: Need to debugy why I changed the matchers first and it will change the schemastore?
        -- │ [schema-companion.nvim] [DEBUG] [...azy/schema-companion.nvim/lua/schema-companion/utils.lua:11]: Ensuring schema exists: uri="https://raw.githubusercontent.com/datreeio/CRDs-catalog/ma │
        -- │ [schema-companion.nvim] [DEBUG] [...azy/schema-companion.nvim/lua/schema-companion/utils.lua:15]: Schema does not exist on remote: uri="https://raw.githubusercontent.com/datreeio/CRDs-c │
        -- │ [schema-companion.nvim] [DEBUG] [...y/schema-companion.nvim/lua/schema-companion/context.lua:46]: bufnr=1 client_id=1 no registered matcher matched this file
        --
        -- add your matchers
        require("schema-companion.matchers.kubernetes").setup({ version = "master" }),
      },
      schemas = {
        -- {
        --   name = "Kubernetes v1.29",
        --   uri =
        --   "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.3-standalone-strict/all.json",
        -- },
      }
    })
  end,
}

--
-- return {
--   "cenk1cenk2/schema-companion.nvim",
--   dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "neovim/nvim-lspconfig" },
--   ft = "yaml",
--   --opts = {
--   config = function()
--     require("configs.schema-companion")
--   end
-- }

-- return {
--   "cenk1cenk2/schema-companion.nvim",
--   optional = false,
--   dependencies = {
--     { "nvim-lua/plenary.nvim" },
--     { "nvim-telescope/telescope.nvim" },
--   },
--   config = function()
--     require("schema-companion").setup({
--       -- if you have telescope you can register the extension
--       enable_telescope = true,
--       formatting = true,
--       log_level = "info",
--       matchers = {
--         -- add your matchers
--         require("schema-companion.matchers.kubernetes").setup({ version = "master" }),
--       },
--       schemas = {
--         {
--           name = "Kubernetes master",
--           uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json",
--         },
--         {
--           name = "Kubernetes v1.30",
--           uri =
--           "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.3-standalone-strict/all.json",
--         },
--         {
--           name = "Protolint",
--           uri = "~/.config/nvim/schemas/protolint.json",
--         },
--       },
--     })
--   end
-- }


-- TODO: install the schema-companion and see how to use it for kubernetes
