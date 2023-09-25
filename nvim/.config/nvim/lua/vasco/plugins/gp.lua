return {
  'robitx/gp.nvim',
  cmd = { 'GpChatToggle' },
  keys = {
    vim.keymap.set('n', '<leader>a', '<cmd>GpChatToggle<cr>', { desc = 'Toggle AI' }),
  },
  config = function()
    require('gp').setup()
  end,
}
