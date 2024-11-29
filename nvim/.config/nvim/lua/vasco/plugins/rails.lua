return {
  'tpope/vim-rails',
  ft = {'ruby', 'eruby'},
  keys = {
    {
      '<leader>rc',
      '<cmd>Econtroller<CR>',
      desc = 'Controller',
    },
    {
      '<leader>rv',
      '<cmd>Eview<CR>',
      desc = 'View',
    },
    {
      '<leader>rh',
      '<cmd>Ehelper<CR>',
      desc = 'Helper',
    },
    {
      '<leader>ra',
      '<cmd>A<CR>',
      desc = 'Alternate',
    },
    {
      '<leader>rl',
      '<cmd>Elocale<CR>',
      desc = 'Locale',
    },
    {
      '<leader>ru',
      '<cmd>Eunittest<CR>',
      desc = 'Unit test',
    },
    {
      '<leader>rm',
      '<cmd>Emodel<CR>',
      desc = 'Model',
    },
  },
}
