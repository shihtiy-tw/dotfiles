-- ~/.config/nvim/lua/plugins/kube-utils.lua
return {
  "h4ckm1n-dev/kube-utils-nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  lazy = true,
  event = "VeryLazy",
  config = function()
    local helm_mappings = {
      { '<leader>lk',  group = '[kubernetes]' },
      { '<leader>lkD', '<cmd>DeleteNamespace<CR>',                desc = 'Kubectl Delete Namespace' },
      { '<leader>lkK', '<cmd>OpenK9sSplit<CR>',                   desc = 'Split View K9s' },
      { '<leader>lkT', '<cmd>HelmDryRun<CR>',                     desc = 'Helm DryRun Buffer' },
      { '<leader>lka', '<cmd>KubectlApplyFromBuffer<CR>',         desc = 'Kubectl Apply From Buffer' },
      { '<leader>lkb', '<cmd>HelmDependencyBuildFromBuffer<CR>',  desc = 'Helm Dependency Build' },
      { '<leader>lkd', '<cmd>HelmDeployFromBuffer<CR>',           desc = 'Helm Deploy Buffer to Context' },
      { '<leader>lkk', '<cmd>OpenK9s<CR>',                        desc = 'Open K9s' },
      { '<leader>lkl', '<cmd>ToggleYamlHelm<CR>',                 desc = 'Toggle YAML/Helm' },
      { '<leader>lkr', '<cmd>RemoveDeployment<CR>',               desc = 'Helm Remove Deployment From Buffer' },
      { '<leader>lkt', '<cmd>HelmTemplateFromBuffer<CR>',         desc = 'Helm Template From Buffer' },
      { '<leader>lku', '<cmd>HelmDependencyUpdateFromBuffer<CR>', desc = 'Helm Dependency Update' },
    }
    local wk = require 'which-key'
    wk.add(helm_mappings)
  end
}
