local colors = require 'vasco.helpers.colors'

local M = {
  'folke/zen-mode.nvim',
}

M.dependencies = {
  'folke/twilight.nvim',
}

M.cmd = 'ZenMode'

function M.config()
  local zen = require 'zen-mode'
  local twilight = require 'twilight'

  zen.setup {
    plugins = {
      tmux = true,
      twilight = true
    },
    window = {
      options = {
        signcolumn = 'no', -- disable signcolumn
        number = false, -- disable number column
        relativenumber = false, -- disable relative numbers
        -- cursorline = false, -- disable cursorline
        cursorcolumn = false, -- disable cursor column
        -- foldcolumn = "0", -- disable fold column
      },
    },
  }

  twilight.setup {
    dimming = {
      alpha = 0.40, -- amount of dimming
      color = { 'Normal', colors.fg },
      term_bg = colors.dark_grey, -- if guibg=NONE, this will be used to calculate text color
      inactive = true, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
    },
  }
end

return M
