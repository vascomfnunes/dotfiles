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
  config = true,
}
