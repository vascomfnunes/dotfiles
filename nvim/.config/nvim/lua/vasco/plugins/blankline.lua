return {
  'lukas-reineke/indent-blankline.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('indent_blankline').setup()
  end,
}
