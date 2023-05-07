local icons = require 'vasco.helpers.icons'
local config = require 'vasco.config'

return {
  'glepnir/lspsaga.nvim',
  event = 'LspAttach',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
    --Please make sure you install markdown and markdown_inline parser
    { 'nvim-treesitter/nvim-treesitter' },
  },
  config = function()
    require('lspsaga').setup {
      code_action = {
        num_shortcut = true,
        show_server_name = false,
        extend_gitsigns = true,
        keys = {
          -- string | table type
          quit = 'q',
          exec = '<C-l>',
        },
      },
      lightbulb = {
        enable = true,
        enable_in_insert = true,
        sign = true,
        sign_priority = 40,
        virtual_text = false,
      },
      rename = {
        quit = '<C-c>',
        exec = '<CR>',
        mark = 'x',
        confirm = '<C-l>',
        in_select = true,
      },
      outline = {
        win_position = 'right',
        win_with = '',
        win_width = 30,
        preview_width = 0.4,
        show_detail = true,
        auto_preview = false,
        auto_refresh = true,
        auto_close = true,
        custom_sort = nil,
        keys = {
          expand_or_jump = 'l',
          quit = 'q',
        },
      },
      symbol_in_winbar = {
        enable = true,
        separator = '  ',
        ignore_patterns = {},
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        respect_root = false,
        color_mode = true,
      },
      ui = {
        -- This option only works in Neovim 0.9
        title = true,
        -- Border type can be single, double, rounded, solid, shadow.
        border = config.border_style,
        winblend = 0,
        expand = '',
        collapse = '',
        code_action = icons.bulb,
        hover = ' ',
        kind = {},
      },
    }
  end,
}
