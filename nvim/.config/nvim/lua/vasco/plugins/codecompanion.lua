return {
  'olimorris/codecompanion.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>at',
      vim.cmd.CodeCompanionToggle,
      desc = 'Toggle',
    },
    {
      '<leader>aa',
      vim.cmd.CodeCompanionActions,
      desc = 'Actions',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ai',
      vim.cmd.CodeCompanion,
      desc = 'In line',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ac',
      '<cmd>CodeCompanionChat<cr>',
      desc = 'New chat',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ag',
      '<cmd>CodeCompanionChat openai<cr>',
      desc = 'New chat (gpt-4)',
      mode = { 'n', 'v' },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
    {
      'stevearc/dressing.nvim',
      opts = {},
    },
  },
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = 'ollama',
        inline = 'ollama',
      },
      adapters = {
        ollama = require('codecompanion.adapters').use('ollama', {
          schema = {
            model = {
              -- default = 'llama3:latest',
              default = 'deepseek-coder:6.7b-instruct-q5_K_M',
            },
          },
        }),
      },
    }
  end,
}
