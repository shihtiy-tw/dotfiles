local cmp = require('cmp')
local luasnip = require('luasnip')

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local cmp_keybind = {
  ['<C-d>'] = cmp.mapping.scroll_docs(4),
  ['<C-f>'] = cmp.mapping.scroll_docs(-4),
  -- ['<S-TAB>'] = cmp.mapping.select_prev_item(),
  -- ['<TAB>'] = cmp.mapping.select_next_item(),
  -- complete
  -- ['<TAB'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
  -- cancel
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    -- local copilot_keys = vim.fn["copilot#Accept"]()
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
      -- elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
      --   vim.api.nvim_feedkeys(copilot_keys, "i", true)
    else
      fallback()
    end
  end, { "i", "s" }),
  ['<A-,>'] = cmp.mapping({
    i = cmp.mapping.abort(),
    c = cmp.mapping.close(),
  }),
  -- Accept currently selected item. If none selected, `select` first item.
  -- Set `select` to `false` to only confirm explicitly selected items.
  ['<ENTER>'] = cmp.mapping.confirm({
    select = true,
    behavior = cmp.ConfirmBehavior.Replace
  }),
  -- ['<C-s>'] = cmp.mapping.confirm({
  --   select = true,
  --   behavior = cmp.ConfirmBehavior.Replace
  -- }),
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
      -- vim.snippet.expand(args.body)
    end,
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip', option = { show_autosnippets = true } },
    { name = 'buffer' },
    { name = 'path' }
  }),

  mapping = cmp_keybind,
}
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    {
      { name = 'path' }
    },
    {
      { name = 'cmdline' }
    }
  )
})
