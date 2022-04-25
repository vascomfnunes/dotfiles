local M = {
  'kosayoda/nvim-lightbulb',
}

M.event = 'BufReadPost'

function M.config()
  local bulb = require 'nvim-lightbulb'
  local icons = require 'vasco.helpers.icons'

  vim.cmd [[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]]

  bulb.setup {
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
  }

  vim.fn.sign_define('LightBulbSign', { text = icons.bulb, texthl = 'LightBulbSign', linehl = '', numhl = '' })
end

return M
