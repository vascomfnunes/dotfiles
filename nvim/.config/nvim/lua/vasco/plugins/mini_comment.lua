return {
  'echasnovski/mini.comment',
  version = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('mini.comment').setup()
  end,
}
