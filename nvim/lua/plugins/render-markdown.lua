return {
  'MeanderingProgrammer/render-markdown.nvim',
  enabled = true,
  version = "*",
  opts = {},
  after = { 'nvim-treesitter' },
  requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
  -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
  -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
  config = function()
    require('render-markdown').setup({
      checkbox = {
        enabled = true,
        position = 'inline',
        unchecked = {
          icon = '󰄱 ',
          highlight = 'RenderMarkdownUnchecked',
        },
        checked = {
          icon = '󰱒 ',
          highlight = 'RenderMarkdownChecked',
        },
        custom = {
          todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
          rightarrow = { raw = '[>]', rendered = ' ', highlight = 'RenderMarkdownRightArrow' },
          tilde = { raw = '[~]', rendered = '󰰱 ', highlight = 'RenderMarkdownTilde' },
          important = { raw = '[!]', rendered = ' ', highlight = 'RenderMarkdownImportant' },
        },
      }
    })
  end,
}
