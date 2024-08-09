return {
  'hedyhli/markdown-toc.nvim',
  ft = 'markdown',
  cmd = { 'Mtoc' },
  config = function()
    require('mtoc').setup()
  end,
  keys = {
    {
      '<leader>mt',
      'cmd>Mtoc i<CR>',
      desc = 'Insert TOC at position',
    },
    {
      '<leader>mu',
      'cmd>Mtoc u<CR>',
      desc = 'Update TOC',
    },
  },
}
