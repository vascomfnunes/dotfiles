return {
  'utilyre/barbecue.nvim',
  version = '*',
  dependencies = { 'smiteshp/nvim-navic' },
  event = 'BufReadPost',
  config = function()
    require('barbecue').setup()
  end,
}
