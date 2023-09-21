return {
  'echasnovski/mini.statusline',
  version = false,
  config = function()
    require('mini.statusline').setup {
      set_vim_settings = false,
    }
  end,
}
