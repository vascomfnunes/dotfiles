return {
  'olimorris/codecompanion.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>at',
      vim.cmd.CodeCompanionToggle,
      desc = 'Toggle'
    },
    {
      '<leader>aa',
      vim.cmd.CodeCompanionActions,
      desc = 'Actions'
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
