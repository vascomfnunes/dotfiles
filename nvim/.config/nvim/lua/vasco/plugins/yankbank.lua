return {
  'ptdewey/yankbank-nvim',
  cmd = 'YankBank',
  keys = {
    {
      '<leader>y',
      vim.cmd.YankBank,
      desc = 'Yank bank',
      mode = { 'n', 'v' },
    },
  },
  config = function()
    require('yankbank').setup()
  end,
}
