local icons = require 'vasco.helpers.icons'

return {
  'lewis6991/gitsigns.nvim',
  lazy = false,
  config = function()
    require('gitsigns').setup()
  end,
}
