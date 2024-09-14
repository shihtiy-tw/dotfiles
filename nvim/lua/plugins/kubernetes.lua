return {
  'diogo464/kubernetes.nvim',
  config = function()
    if vim.g.os == "Linux" then
      require('kubernetes').setup()
    end
  end
}
