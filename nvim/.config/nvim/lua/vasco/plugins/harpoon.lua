return {
  'ThePrimeagen/harpoon',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    {
      '<leader>ha',
      function()
        require('harpoon.mark').add_file()
      end,
      desc = 'Add file',
    },

    {
      '<leader>hh',
      function()
        require('harpoon.mark').toggle_quick_menu()
      end,
      desc = 'Toggle files',
    },
  },
}
