return {
  'RRethy/base16-nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('base16-colorscheme').with_config {
      telescope = false,
    }
    vim.cmd.colorscheme 'vim'
  end,
}
