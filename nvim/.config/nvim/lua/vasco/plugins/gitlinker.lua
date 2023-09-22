return {
  'ruifm/gitlinker.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'BufReadPost',
  keys = {
    vim.keymap.set({ 'n', 'v' }, '<leader>gy', function()
      require('gitlinker.actions').clipboard()
    end, { desc = 'Yank repository URL line' }),
  },
  opts = {},
}
