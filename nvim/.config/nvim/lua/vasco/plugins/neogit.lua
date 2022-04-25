local M = {
  'TimUntersberger/neogit',
}

M.dependencies = 'sindrets/diffview.nvim'
M.cmd = 'Neogit'

function M.config()
  local neogit = require 'neogit'

  local icons = require 'vasco.helpers.icons'

  neogit.setup {
    disable_signs = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = false,
    -- customize displayed signs
    signs = {
      -- { CLOSED, OPENED }
      section = { icons.right_arrow, icons.down_arrow },
      item = { icons.right_arrow, icons.down_arrow },
      hunk = { '', '' },
    },
    integrations = { diffview = true },
  }
end

return M
