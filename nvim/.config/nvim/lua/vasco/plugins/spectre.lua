return {
  'nvim-pack/nvim-spectre', -- requires 'brew install gnu-sed'
  cmd = 'Spectre',
  keys = {
    vim.keymap.set('n', '<leader>ss', function()
      require('spectre').open()
    end, { desc = 'LSP Open search & replace' }),

    vim.keymap.set({ 'n', 'v' }, '<leader>sg', function()
      require('spectre').open_visual { select_word = true }
    end, { desc = 'Grep current string' }),
  },
  opts = { open_cmd = 'noswapfile vnew' },
}
