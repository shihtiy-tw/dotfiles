return {
  {
    "ramilito/kubectl.nvim",
    config = function()
      require("kubectl").setup()
    end,
    keys = {
      -- General keys
      { "dd", "<Plug>(kubectl.kill)",          ft = "k8s_*" },
      { "q",  "<Plug>(kubectl.quit)",          ft = "k8s_*" },
      -- views
      { "7",  "<Plug>(kubectl.view_nodes)",    ft = "k8s_*" },
      { "8",  "<Plug>(kubectl.view_top)",      ft = "k8s_*" },
      { "0",  "<Plug>(kubectl.view_overview)", ft = "k8s_*" },
      -- {
      --   'Z',
      --   function()
      --     local state = require 'kubectl.state'
      --     local current = state.getFilter()
      --     local faults_filter = '!1/1,!2/2,!3/3,!4/4,!5/5,!6/6,!7/7,!Completed,!Terminating'
      --     if current == faults_filter then
      --       state.setFilter ''
      --       return
      --     end
      --     state.setFilter(faults_filter)
      --   end,
      --   desc = 'Toggle faults',
      -- },

    },

    -- -- Global
    -- k("n", "<Plug>(kubectl.help)", "g?", opts)              -- Help float
    -- k("n", "<Plug>(kubectl.refresh)", "gr", opts)           -- Refresh view
    -- k("n", "<Plug>(kubectl.sort)", "gs", opts)              -- Sort by column
    -- k("n", "<Plug>(kubectl.delete)", "gD", opts)            -- Delete resource
    -- k("n", "<Plug>(kubectl.describe)", "gd", opts)          -- Describe resource
    -- k("n", "<Plug>(kubectl.edit)", "ge", opts)              -- Edit resource
    -- k("n", "<Plug>(kubectl.filter_label)", "<C-l>", opts)   -- Filter labels
    -- k("n", "<Plug>(kubectl.go_up)", "<BS>", opts)           -- Go back to previous view
    -- k("v", "<Plug>(kubectl.filter_term)", "<C-f>", opts)    -- Filter selected text
    -- k("n", "<Plug>(kubectl.select)", "<CR>", opts)          -- Resource select action (different on each view)
    -- k("n", "<Plug>(kubectl.tab)", "<Tab>", opts)            -- Tab completion (ascending, when applicable)
    -- k("n", "<Plug>(kubectl.shift_tab)", "<Tab>", opts)      -- Tab completion (descending, when applicable)
    -- k("n", "<Plug>(kubectl.quit)", "", opts)                -- Close view (when applicable)
    -- k("n", "<Plug>(kubectl.kill)", "gk", opts)              -- Pod/portforward kill
    -- k("n", "<Plug>(kubectl.toggle_headers)", "<M-h>", opts) -- Toggle headers
    --
    -- -- Views
    -- k("n", "<Plug>(kubectl.alias_view)", "<C-a>", opts)         -- Aliases view
    -- k("n", "<Plug>(kubectl.contexts_view)", "<C-x>", opts)      -- Contexts view
    -- k("n", "<Plug>(kubectl.filter_view)", "<C-f>", opts)        -- Filter view
    -- k("n", "<Plug>(kubectl.namespace_view)", "<C-n>", opts)     -- Namespaces view
    -- k("n", "<Plug>(kubectl.portforwards_view)", "gP", opts)     -- Portforwards view
    -- k("n", "<Plug>(kubectl.view_deployments)", "1", opts)       -- Deployments view
    -- k("n", "<Plug>(kubectl.view_pods)", "2", opts)              -- Pods view
    -- k("n", "<Plug>(kubectl.view_configmaps)", "3", opts)        -- ConfigMaps view
    -- k("n", "<Plug>(kubectl.view_secrets)", "4", opts)           -- Secrets view
    -- k("n", "<Plug>(kubectl.view_services)", "5", opts)          -- Services view
    -- k("n", "<Plug>(kubectl.view_ingresses)", "6", opts)         -- Ingresses view
    -- k("n", "<Plug>(kubectl.view_api_resources)", "", opts)      -- API-Resources view
    -- k("n", "<Plug>(kubectl.view_clusterrolebinding)", "", opts) -- ClusterRoleBindings view
    -- k("n", "<Plug>(kubectl.view_crds)", "", opts)               -- CRDs view
    -- k("n", "<Plug>(kubectl.view_cronjobs)", "", opts)           -- CronJobs view
    -- k("n", "<Plug>(kubectl.view_daemonsets)", "", opts)         -- DaemonSets view
    -- k("n", "<Plug>(kubectl.view_events)", "", opts)             -- Events view
    -- k("n", "<Plug>(kubectl.view_helm)", "", opts)               -- Helm view
    -- k("n", "<Plug>(kubectl.view_jobs)", "", opts)               -- Jobs view
    -- k("n", "<Plug>(kubectl.view_nodes)", "", opts)              -- Nodes view
    -- k("n", "<Plug>(kubectl.view_overview)", "", opts)           -- Overview view
    -- k("n", "<Plug>(kubectl.view_pv)", "", opts)                 -- PersistentVolumes view
    -- k("n", "<Plug>(kubectl.view_pvc)", "", opts)                -- PersistentVolumeClaims view
    -- k("n", "<Plug>(kubectl.view_sa)", "", opts)                 -- ServiceAccounts view
    -- k("n", "<Plug>(kubectl.view_top_nodes)", "", opts)          -- Top view for nodes
    -- k("n", "<Plug>(kubectl.view_top_pods)", "", opts)           -- Top view for pods
    --
    -- -- Deployment/DaemonSet actions
    -- k("n", "<Plug>(kubectl.rollout_restart)", "grr", opts) -- Rollout restart
    -- k("n", "<Plug>(kubectl.scale)", "gss", opts)           -- Scale workload
    -- k("n", "<Plug>(kubectl.set_image)", "gi", opts)        -- Set image (only if 1 container)
    --
    -- -- Pod/Container logs
    -- k("n", "<Plug>(kubectl.logs)", "gl", opts)       -- Logs view
    -- k("n", "<Plug>(kubectl.history)", "gh", opts)    -- Change logs --since= flag
    -- k("n", "<Plug>(kubectl.follow)", "f", opts)      -- Follow logs
    -- k("n", "<Plug>(kubectl.wrap)", "gw", opts)       -- Toggle wrap log lines
    -- k("n", "<Plug>(kubectl.prefix)", "gp", opts)     -- Toggle container name prefix
    -- k("n", "<Plug>(kubectl.timestamps)", "gt", opts) -- Toggle timestamps prefix
    --
    -- -- Node actions
    -- k("n", "<Plug>(kubectl.cordon)", "gC", opts)   -- Cordon node
    -- k("n", "<Plug>(kubectl.uncordon)", "gU", opts) -- Uncordon node
    -- k("n", "<Plug>(kubectl.drain)", "gR", opts)    -- Drain node
    --
    -- -- Top actions
    -- k("n", "<Plug>(kubectl.top_nodes)", "gn", opts) -- Top nodes
    -- k("n", "<Plug>(kubectl.top_pods)", "gp", opts)  -- Top pods
    --
    -- -- CronJob/Job actions
    -- k("n", "<Plug>(kubectl.suspend_job)", "gx", opts) -- only for CronJob
    -- k("n", "<Plug>(kubectl.create_job)", "gc", opts)  -- Create Job from CronJob or Job
    --
    -- k("n", "<Plug>(kubectl.portforward)", "gp", opts) -- Pods/Services portforward
    -- k("n", "<Plug>(kubectl.browse)", "gx", opts)      -- Ingress view
    -- k("n", "<Plug>(kubectl.yaml)", "gy", opts)        -- Helm view
  },
}
