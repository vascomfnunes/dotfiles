return {
  'robitx/gp.nvim',
  -- commit = '795cd912e7ae9993e2bab6d4ff53fc16a19941f2',
  cmd = { 'GpChatToggle' },
  keys = {
    { '<leader>a', '<cmd>GpChatToggle<cr>', desc = 'Toggle AI' },
  },
  config = function()
    require('gp').setup {
      chat_model = { model = 'gpt-3.5-turbo-16k', temperature = 1.1, top_p = 1 },
      command_model = { model = 'gpt-3.5-turbo-16k', temperature = 1.1, top_p = 1 },
    }
  end,
}
