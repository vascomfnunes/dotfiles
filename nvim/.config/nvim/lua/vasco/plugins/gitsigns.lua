local icons = require 'vasco.helpers.icons'

return {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPost',
  opts = {
    signs = {
      add = { text = icons.git_add },
      change = { text = icons.git_change },
      delete = { text = icons.git_delete },
      topdelete = { text = '‾' },
      changedelete = { text = icons.git_change },
    },
  },
}
