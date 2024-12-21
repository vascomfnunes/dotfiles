return {
  'folke/trouble.nvim',
  opts = {
    default = {
      auto_close = true,
      focus = true,
    },
  },
  cmd = 'Trouble',
  keys = {
    {
      '<leader>cd',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Diagnostics (Trouble)',
    },
  },
}
