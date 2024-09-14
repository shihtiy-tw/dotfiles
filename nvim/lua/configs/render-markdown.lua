require('render-markdown').setup({
  file_types = { 'markdown', 'quatro' },
  link = {
    -- Turn on / off inline link icon rendering
    enabled = false,
    -- Inlined with 'image' elements
    image = '󰥶 ',
    -- Inlined with 'email_autolink' elements
    email = '󰀓 ',
    -- Fallback icon for 'inline_link' elements
    hyperlink = '󰌹 ',
    -- Applies to the fallback inlined icon
    highlight = 'RenderMarkdownLink',
    -- Define custom destination patterns so icons can quickly inform you of what a link
    -- contains. Applies to 'inline_link' and wikilink nodes.
    -- Can specify as many additional values as you like following the 'web' pattern below
    --   The key in this case 'web' is for healthcheck and to allow users to change its values
    --   'pattern':   Matched against the destination text see :h lua-pattern
    --   'icon':      Gets inlined before the link text
    --   'highlight': Highlight for the 'icon'
    custom = {
      web = { pattern = '^http[s]?://', icon = '󰖟 ', highlight = 'RenderMarkdownLink' },
    },
  },
})
