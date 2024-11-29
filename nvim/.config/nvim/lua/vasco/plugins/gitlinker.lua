return {
  'ruifm/gitlinker.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'BufReadPost',
  keys = {
    {
      '<leader>gy',
      function()
        require('gitlinker.actions').clipboard()
      end,
      desc = 'Yank repository URL line',
      mode = { 'n', 'v' },
    },
  },
  opts = {},
}
