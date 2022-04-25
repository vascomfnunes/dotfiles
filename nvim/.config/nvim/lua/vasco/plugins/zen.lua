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
      -- we try to get the foreground from the highlight groups or fallback color
      color = { 'Normal', '#ffffff' },
      term_bg = '#000000', -- if guibg=NONE, this will be used to calculate text color
      inactive = true, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
    },
  }
end

return M
