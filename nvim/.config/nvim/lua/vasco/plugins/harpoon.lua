return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>ha',
      function()
        require('harpoon'):list():add()
      end,
      desc = 'Harpoon File',
    },
    {
      '<leader>hl',
      function()
        local harpoon = require 'harpoon'
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = 'List harpoons',
    },
  },
}
