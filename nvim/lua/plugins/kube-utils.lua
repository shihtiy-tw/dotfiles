-- ~/.config/nvim/lua/plugins/kube-utils.lua
return {
  "h4ckm1n-dev/kube-utils-nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  lazy = true,
  event = "VeryLazy",
  config = function()
    local helm_mappings = {
      { '<leader>K',  group = '[kubernetes]' },
      { '<leader>KD', '<cmd>DeleteNamespace<CR>',                desc = 'Kubectl Delete Namespace' },
      { '<leader>KK', '<cmd>OpenK9sSplit<CR>',                   desc = 'Split View K9s' },
      { '<leader>KT', '<cmd>HelmDryRun<CR>',                     desc = 'Helm DryRun Buffer' },
      { '<leader>Ka', '<cmd>KubectlApplyFromBuffer<CR>',         desc = 'Kubectl Apply From Buffer' },
      { '<leader>Kb', '<cmd>HelmDependencyBuildFromBuffer<CR>',  desc = 'Helm Dependency Build' },
      { '<leader>Kd', '<cmd>HelmDeployFromBuffer<CR>',           desc = 'Helm Deploy Buffer to Context' },
      -- { '<leader>Kk', '<cmd>OpenK9s<CR>',                        desc = 'Open K9s' },
      { '<leader>KY', '<cmd>ToggleYamlHelm<CR>',                 desc = 'Toggle YAML/Helm' },
      { '<leader>Kl', '<cmd>ViewPodLogs<CR>',                    desc = 'View Pod Logs' },
      { '<leader>Kr', '<cmd>RemoveDeployment<CR>',               desc = 'Helm Remove Deployment From Buffer' },
      { '<leader>Kt', '<cmd>HelmTemplateFromBuffer<CR>',         desc = 'Helm Template From Buffer' },
      { '<leader>Ku', '<cmd>HelmDependencyUpdateFromBuffer<CR>', desc = 'Helm Dependency Update' },
    }
    local wk = require 'which-key'
    wk.add(helm_mappings)
    require("kube-utils-nvim").setup()
  end
}
