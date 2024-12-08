local icons = require 'vasco.utils.icons'

return {
  'folke/which-key.nvim',
  module = true,
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    preset = 'modern',
    icons = {
      breadcrumb = icons.breadcrumb,
      separator = icons.right_arrow,
      group = icons.plus,
    },
    layout = {
      width = { min = 20, max = 50 },
      spacing = 4,
      align = 'left',
    },
  },
  config = function()
    local wk = require 'which-key'

    wk.add {
      { '<leader><tab>', group = 'Tabs' },
      { '<leader>C', group = 'Colours' },
      { '<leader>b', group = 'Buffers' },
      { '<leader>c', group = 'Code' },
      { '<leader>f', group = 'Files' },
      { '<leader>g', group = 'Git' },
      { '<leader>h', group = 'Harpoon' },
      { '<leader>m', group = 'Markdown' },
      { '<leader>n', group = 'Notes' },
      { '<leader>q', group = 'Quickfix' },
      { '<leader>r', group = 'Rails' },
      { '<leader>s', group = 'Search/Replace' },
      { '<leader>T', group = 'Tests' },
      { '<leader>t', group = 'Terminal' },
      { '<leader>u', group = 'Utils' },
      { '<leader>d', group = 'Debug' },
      { '<leader>v', group = 'Vim Configuration' },
      { '<leader>a', group = 'AI Assistant' },
      {
        mode = { 'v' },
        { '<leader>a', group = 'AI Assistant' },
        { '<leader>c', group = 'Code' },
        { '<leader>g', group = 'Git' },
        { '<leader>s', group = 'Quickfix' },
      },
    }
  end,
}
