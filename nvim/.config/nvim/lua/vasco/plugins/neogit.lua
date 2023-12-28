local icons = require 'vasco.utils.icons'

return {
  'NeogitOrg/neogit',
  dependencies = { 'sindrets/diffview.nvim', 'nvim-lua/plenary.nvim' },
  cmd = 'Neogit',
  keys = {
    { '<leader>gg', vim.cmd.Neogit, desc = 'Neogit' },
  },
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
