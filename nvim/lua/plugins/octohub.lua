return {
  {
    '2kabhishek/octohub.nvim',
    cmd = {
      'OctoRepos',
      'OctoReposByCreated',
      'OctoReposByForks',
      'OctoReposByIssues',
      'OctoReposByLanguages',
      'OctoReposByNames',
      'OctoReposByPushed',
      'OctoReposBySize',
      'OctoReposByStars',
      'OctoReposByUpdated',
      'OctoReposTypeArchived',
      'OctoReposTypeForked',
      'OctoReposTypePrivate',
      'OctoReposTypeStarred',
      'OctoReposTypeTemplate',
      'OctoRepo',
      'OctoStats',
      'OctoActivityStats',
      'OctoContributionStats',
      'OctoRepoStats',
      'OctoProfile',
      'OctoRepoWeb',
    },
    -- Change these if you do not want to use default keybindings
    keys = {
      '<leader>goa',
      '<leader>goA',
      '<leader>gob',
      '<leader>goc',
      '<leader>gof',
      '<leader>goF',
      '<leader>gog',
      '<leader>goi',
      '<leader>gol',
      '<leader>goo',
      '<leader>gop',
      '<leader>goP',
      '<leader>gor',
      '<leader>gos',
      '<leader>goS',
      '<leader>got',
      '<leader>goT',
      '<leader>gou',
      '<leader>goU',
      '<leader>gow',
    },
    dependencies = {
      '2kabhishek/utils.nvim',
      '2kabhishek/pickme.nvim',
    },
    -- Add your custom configs here, keep it blank for default configs (required)
    opts = {},
    config = function()
      require("configs.octohub")
    end
  },
  {
    '2KAbhishek/pickme.nvim',
    cmd = 'PickMe',
    event = 'VeryLazy',
    dependencies = {
      -- Include at least one of these pickers:
      -- 'folke/snacks.nvim', -- For snacks.picker
      'nvim-telescope/telescope.nvim', -- For telescope
      -- 'ibhagwan/fzf-lua', -- For fzf-lua
    },
    opts = {
      picker_provider = 'telescope', -- Default provider
      add_default_keybindings = false
    },
  }
}
