return {
  'echasnovski/mini.statusline',
  version = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('mini.statusline').setup {
      set_vim_settings = false,
    }
  end,
}
