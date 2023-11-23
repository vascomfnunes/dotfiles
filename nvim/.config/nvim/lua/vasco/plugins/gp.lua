return {
  'robitx/gp.nvim',
  cmd = { 'GpChatToggle' },
  keys = {
    { '<leader>a', '<cmd>GpChatToggle<cr>', desc = 'Toggle AI' },
  },
  opts = {
    chat_model = { model = 'gpt-3.5-turbo-16k', temperature = 1.1, top_p = 1 },
    command_model = { model = 'gpt-3.5-turbo-16k', temperature = 1.1, top_p = 1 },
  },
}
