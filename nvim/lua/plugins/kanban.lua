return {
  "arakkkkk/kanban.nvim",
  -- Optional
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },

  keys = {
    -- Default
    { "<C-c>",      "<esc>",                             mode = "i", desc = "Escape insert mode" },
    { "<C-o>",      "k",                                 mode = "n", desc = "Move up" },
    { ":q<cr>",     "<cmd>KanbanClose<cr>",              mode = "n", desc = "Close Kanban" },
    { "q",          "<cmd>KanbanClose<cr>",              mode = "n", desc = "Close Kanban" },

    -- Task movement
    { "L",          "<cmd>KanbanTakeRight<cr>",          mode = "n", desc = "Move task right" },
    { "H",          "<cmd>KanbanTakeLeft<cr>",           mode = "n", desc = "Move task left" },
    { "K",          "<cmd>KanbanTakeUp<cr>",             mode = "n", desc = "Move task up" },
    { "J",          "<cmd>KanbanTakeDown<cr>",           mode = "n", desc = "Move task down" },

    -- Task navigation
    { "<C-j>",      "<cmd>KanbanMoveDown<cr>",           mode = "n", desc = "Navigate down" },
    { "<C-k>",      "<cmd>KanbanMoveUp<cr>",             mode = "n", desc = "Navigate up" },
    { "<C-l>",      "<cmd>KanbanMoveRight<cr>",          mode = "n", desc = "Navigate right" },
    { "<C-h>",      "<cmd>KanbanMoveLeft<cr>",           mode = "n", desc = "Navigate left" },
    { "gg",         "<cmd>KanbanMoveTop<cr>",            mode = "n", desc = "Navigate to top" },
    { "G",          "<cmd>KanbanMoveBottom<cr>",         mode = "n", desc = "Navigate to bottom" },

    -- Task manager
    { "D",          "<cmd>KanbanTaskDelete<cr>",         mode = "n", desc = "Delete task" },
    { "<C-o>",      "<cmd>KanbanTaskAdd<cr>",            mode = "n", desc = "Add task" },
    { "<C-t>",      "<cmd>KanbanTaskToggleComplete<cr>", mode = "n", desc = "Toggle task completion" },

    -- List manager
    { "<leader>ld", "<cmd>KanbanListDelete<cr>",         mode = "n", desc = "Delete list" },
    { "<leader>lr", "<cmd>KanbanListRename<cr>",         mode = "n", desc = "Rename list" },
    { "<leader>la", "<cmd>KanbanListAdd<cr>",            mode = "n", desc = "Add list" },

    -- Description note
    { "<CR>",       "<cmd>KanbanTaskDescription<cr>",    mode = "n", desc = "View task description" },
  },


  config = function()
    require("kanban").setup({
      markdown = {
        description_folder = "./tasks/", -- Path to save the file corresponding to the task.
        list_head = "## ",
      },
    })
  end,
}
