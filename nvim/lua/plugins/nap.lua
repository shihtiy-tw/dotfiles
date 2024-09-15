return {
"liangxianzhe/nap.nvim",
config = function()
  require("nap").setup({
    next_prefix = "]",
    prev_prefix = "[",
    next_repeat = "<c-n>",
    prev_repeat = "<c-p>",
    -- to exclude some keys from the default
    exclude_default_operators = {"a", "A"},
    -- to add custom keys
    operators = {},
  })
end
}
