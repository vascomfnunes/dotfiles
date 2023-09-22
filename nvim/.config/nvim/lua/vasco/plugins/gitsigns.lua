local icons = require 'vasco.helpers.icons'

return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    vim.keymap.set('n', '<leader>gb', function()
      require('gitsigns').blame_line()
    end, { desc = 'Blame' }),

    vim.keymap.set('n', '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<cr>', { desc = 'Unstage hunk' }),
    vim.keymap.set('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', { desc = 'Reset hunk' }),
    vim.keymap.set('n', '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', { desc = 'Stage hunk' }),
    vim.keymap.set('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', { desc = 'Preview hunk' }),
  },
  opts = {},
}
