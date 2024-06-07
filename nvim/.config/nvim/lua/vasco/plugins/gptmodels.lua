return {
  'Aaronik/GPTModels.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    vim.api.nvim_set_keymap('v', '<leader>aa', ':GPTModelsCode<CR>', { noremap = true, desc = 'Code assistant' })
    vim.api.nvim_set_keymap('n', '<leader>aa', ':GPTModelsCode<CR>', { noremap = true, desc = 'Code assistant' })

    vim.api.nvim_set_keymap('v', '<leader>ar', ':GPTModelsChat<CR>', { noremap = true, desc = 'Chat' })
    vim.api.nvim_set_keymap('n', '<leader>ac', ':GPTModelsChat<CR>', { noremap = true, desc = 'Chat' })
  end,
}
