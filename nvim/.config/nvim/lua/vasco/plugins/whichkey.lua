local icons = require 'vasco.utils.icons'
local config = require 'vasco.config'

return {
  'folke/which-key.nvim',
  module = true,
  event = 'VimEnter',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    preset = 'modern',
    ignore_missing = true,
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      i = { 'j', 'k' },
      v = { 'j', 'k' },
    },
    sorting = {
      enable = true, -- sort by alphabet for same-level keys
    },
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
    window = {
      border = config.border.style,
      position = 'bottom', -- bottom, top
      margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    },
  },
  config = function()
    local wk = require 'which-key'

    wk.add {
      { '<leader><tab>', group = 'Tabs' },
      { '<leader>C', group = 'Colours' },
      { '<leader>d', group = 'Database' },
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
      { '<leader>D', group = 'Debug' },
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
