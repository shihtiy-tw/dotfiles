-- "dark" for dark mode; "light" for light mode"
-- gruvbox for darx
-- https://github.com/ellisonleao/gruvbox.nvim
-- solarized for light
-- https://github.com/shaunsingh/solarized.nvim

local theme = os.getenv("THEME")
if theme then
  vim.o.background = theme
else
  vim.o.background = "dark"
end

if vim.o.background == "light" then
  require('solarized').set()
  vim.cmd([[colorscheme solarized]])
else
  vim.cmd([[colorscheme gruvbox]])
end
