return {
  'echasnovski/mini.jump2d',
  version = false,
  lazy = false,
  config = function()
    require('mini.jump2d').setup {
      mappings = {
        start_jumping = 's',
      },
    }
  end,
}
