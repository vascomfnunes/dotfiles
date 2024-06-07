return {
  'Aaronik/GPTModels.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    {
      '<leader>ac',
      vim.cmd.GPTModelsCode,
      desc = 'Code assistant',
    },

    {
      '<leader>aC',
      vim.cmd.GPTModelsChat,
      desc = 'Chat',
    },
  },
}
