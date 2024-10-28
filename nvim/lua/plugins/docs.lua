return {
  "amrbashir/nvim-docs-view",
  lazy = true,
  cmd = "DocsViewToggle",
  opts = {
    position = "bottom",
    width = 60,
    height = 15,
    -- FIX: not sure why the docs view will not be updated automatically
    update_mode = "auto"
  }
}
