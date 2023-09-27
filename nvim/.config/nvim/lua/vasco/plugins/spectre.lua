return {
  'nvim-pack/nvim-spectre', -- requires 'brew install gnu-sed'
  cmd = 'Spectre',
  keys = {
    {
      '<leader>ss',
      function()
        require('spectre').open()
      end,
      desc = 'LSP Open search & replace',
    },
    {
      '<leader>sg',
      function()
        require('spectre').open_visual { select_word = true }
      end,
      desc = 'Grep current string',
      mode = { 'n', 'v' },
    },
  },
  opts = { open_cmd = 'noswapfile vnew' },
}
