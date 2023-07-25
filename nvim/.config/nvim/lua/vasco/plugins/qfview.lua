return {
  'ashfinal/qfview.nvim',
  event = 'VeryLazy',
  config = function()
    require('qfview').setup()
  end,
}
