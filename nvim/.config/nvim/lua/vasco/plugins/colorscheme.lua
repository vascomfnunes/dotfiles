return {
  'RRethy/base16-nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('base16-colorscheme').with_config {
      telescope = false,
    }
    vim.cmd 'colorscheme base16-gruvbox-material-dark-medium'
    vim.cmd 'hi WhichKeyNormal guibg=#333333'
  end,
}
