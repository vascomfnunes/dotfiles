return {
  'MagicDuck/grug-far.nvim',
  cmd = 'Grugfar',
  config = function()
    require('grug-far').setup {}
  end,
  keys = {
    {
      '<leader>ss',
      function()
        require('grug-far').grug_far {}
      end,
      desc = 'Search & replace',
      mode = { 'n', 'v' },
    },
    {
      '<leader>sg',
      function()
        require('grug-far').grug_far { prefills = { search = vim.fn.expand '<cword>' } }
      end,
      desc = 'Search & replace current string',
      mode = { 'n', 'v' },
    },
  },
}
