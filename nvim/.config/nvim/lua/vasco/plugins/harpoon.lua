return {
  'ThePrimeagen/harpoon',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    vim.keymap.set('n', '<leader>ha', function()
      require('harpoon.mark').add_file()
    end, { desc = 'Add file' }),

    vim.keymap.set('n', '<leader>hh', function()
      require('harpoon.mark').toggle_quick_menu()
    end, { desc = 'Toggle files' }),
  },
}
