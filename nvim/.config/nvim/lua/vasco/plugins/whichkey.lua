local config = require 'vasco.config'
local icons = require 'vasco.utils.icons'

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
        border = config.border.style,
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
      p = { name = 'Co-pilot' },
      g = { name = 'Git' },
      m = { name = 'Markdown' },
      t = { name = 'Tests' },
      f = { name = 'Files' },
      h = { name = 'Harpoon' },
      T = { name = 'Theme' },
      b = { name = 'Buffers' },
      c = { name = 'Code' },
      q = { name = 'Quickfix' },
      s = { name = 'Search/Replace' },
      u = { name = 'Utils' },
      n = { name = 'Notes' },
      v = { name = 'Vim Configuration' },
      r = { name = 'Rails' },
      ['<tab>'] = { name = 'Tabs' },
    }, { prefix = '<leader>', mode = { 'n' } })

    require('which-key').register({
      a = { name = 'AI Assistant' },
      g = { name = 'Git' },
      c = { name = 'Code' },
      s = { name = 'Quickfix' },
    }, { prefix = '<leader>', mode = { 'v' } })
  end,
}
