require('markdown-table-mode').setup({
  filetype = {
    '*.md',
  },
  options = {
    insert = true, -- when typeing "|"
    insert_leave = true, -- when leaveing insert
  },
})
