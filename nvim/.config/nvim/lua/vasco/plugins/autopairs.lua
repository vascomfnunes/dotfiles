return {
  'windwp/nvim-autopairs',
  event = 'BufReadPost',
  config = function()
    require('nvim-autopairs').setup {}
  end,
}
