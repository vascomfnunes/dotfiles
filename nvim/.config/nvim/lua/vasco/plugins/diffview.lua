return {
  'sindrets/diffview.nvim',
  cmd = 'DiffviewOpen',
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Open diff view' },
    { '<leader>gD', '<cmd>DiffviewClose<cr>', desc = 'Close diff view' },
  },
}
