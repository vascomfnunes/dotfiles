local icons = require 'vasco.helpers.icons'

return {
  'TimUntersberger/neogit',
  dependencies = 'sindrets/diffview.nvim',
  cmd = 'Neogit',
  opts = {
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
  },
}
