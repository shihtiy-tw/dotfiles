return {
  "moyiz/git-dev.nvim",
  lazy = true,
  cmd = {
    "GitDevClean",
    "GitDevCleanAll",
    "GitDevCloseBuffers",
    "GitDevOpen",
    "GitDevRecents",
    "GitDevToggleUI",
    "GitDevXDGHandle",
  },
  keys = {
    {
      "<leader>gO",
      function()
        local repo = vim.fn.input "Repository name / URI: "
        if repo ~= "" then
          require("git-dev").open(repo)
        end
      end,
      desc = "[O]pen a remote git repository",
    }
  },
  opts = {
    -- Whether to delete an opened repository when nvim exits.
    -- If `true`, it will create an auto command for opened repositories
    -- to delete the local directory when nvim exists.
    ephemeral = false,
    -- Set buffers of opened repositories to be read-only and unmodifiable.
    read_only = true,
    verbose = true,
  },
  -- config = function()
  --   require("configs.git-dev")
  -- end
}
