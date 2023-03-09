local icons = require 'vasco.helpers.icons'

return {
  'kosayoda/nvim-lightbulb',
  event = 'BufReadPost',
  opts = {
    -- LSP client names to ignore
    ignore = { 'lua' },
    sign = {
      enabled = true,
      priority = 1000,
    },
    float = {
      enabled = false,
      text = icons.bulb,
      winblend = 0,
      win_opts = {},
    },
    autocmd = {
      enabled = false,
      pattern = { '*' },
      events = { 'CursorHold', 'CursorHoldI' },
    },
  },
  config = function()
    vim.fn.sign_define('LightBulbSign', { text = icons.bulb, texthl = 'LightBulbSign', linehl = '', numhl = '' })
    vim.cmd [[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]]
  end,
}
