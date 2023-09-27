local config = require 'vasco.config'
local icons = require 'vasco.helpers.icons'

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    require('which-key').setup {
      icons = {
        breadcrumb = icons.breadcrumb,
        separator = icons.right_arrow,
        group = icons.plus,
      },
      window = {
        border = config.border_style,
        position = 'bottom',
        margin = { 0, 0, 0, 0 },
        padding = { 0, 0, 0, 0 },
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 4,
        align = 'left',
      },
    }
    require('which-key').register({
      g = { name = 'Git' },
      m = { name = 'Markdown' },
      t = { name = 'Tests' },
      f = { name = 'Files' },
      h = { name = 'Harpoon' },
      T = { name = 'Theme' },
      b = { name = 'Buffers' },
      c = { name = 'Code' },
      q = { name = 'Quickfix' },
      s = { name = 'Quickfix' },
      u = { name = 'Updates' },
      r = { name = 'Rails' },
      ['<tab>'] = { name = 'Tabs' },
    }, { prefix = '<leader>' })
  end,
}
