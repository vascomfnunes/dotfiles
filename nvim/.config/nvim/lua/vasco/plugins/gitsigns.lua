return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    {
      '<leader>gb',
      function()
        require('gitsigns').blame_line()
      end,
      desc = 'Blame',
    },

    { '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Unstage hunk' },
    { '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', desc = 'Reset hunk' },
    { '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', desc = 'Stage hunk' },
    { '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', desc = 'Preview hunk' },
    { '<leader>gd', '<cmd>Gitsigns diffthis<cr>', desc = 'Diff hunk' },
  },
  opts = {},
}
