return {
  'fasterius/simple-zoom.nvim',
  event = 'WinNew',
  config = true,
  keys = {
    { '<leader>z', "<cmd>lua require('simple-zoom').toggle_zoom()<cr>", desc = 'Toggle split zoom' },
  },
}
