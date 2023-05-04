return {
  'folke/zen-mode.nvim',
  dependencies = {
    'folke/twilight.nvim',
  },
  cmd = 'ZenMode',
  config = function()
    local zen = require 'zen-mode'
    local twilight = require 'twilight'

    zen.setup {
      plugins = {
        tmux = true,
        twilight = true,
      },
      window = {
        options = {
          signcolumn = 'no', -- disable signcolumn
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorcolumn = false, -- disable cursor column
        },
      },
    }

    twilight.setup {
      dimming = {
        alpha = 0.40, -- amount of dimming
        inactive = true, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
      },
    }
  end,
}
