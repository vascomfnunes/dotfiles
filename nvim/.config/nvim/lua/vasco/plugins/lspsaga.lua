local icons = require 'vasco.helpers.icons'
local config = require 'vasco.config'

return {
  'glepnir/lspsaga.nvim',
  event = 'LspAttach',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
    { 'nvim-treesitter/nvim-treesitter' },
  },
  keys = {
    { '<leader>ck', '<cmd>Lspsaga hover_doc<cr>', desc = 'LSP documentation' },
    { '<leader>cd', '<cmd>Lspsaga goto_definition<cr>', desc = 'Go to definition' },
    { '<leader>cx', '<cmd>Lspsaga show_buf_diagnostics<cr>', desc = 'Show buffer diagnostics' },
    { '<leader>cr', '<cmd>Lspsaga lsp_finder<cr>', desc = 'References' },
    { '<leader>cR', '<cmd>Lspsaga rename<cr>', desc = 'Rename' },
    { '<leader>cl', '<cmd>Lspsaga show_line_diagnostics<cr>', desc = 'Line diagnostics' },
    { '<leader>c]', '<cmd>Lspsaga diagnostic_jump_next<cr>', desc = 'Next diagnostic' },
    { '<leader>c[', '<cmd>Lspsaga diagnostic_jump_previous<cr>', desc = 'Previous diagnostic' },
    { '<leader>co', '<cmd>Lspsaga outline<cr>', desc = 'Code outline' },
    { '<leader>ca', '<cmd>Lspsaga code_action<cr>', desc = 'Code actions' },
    {
      '<leader>cX',
      function()
        vim.diagnostic.config { signs = false, virtual_text = false }
      end,
      desc = 'Hide diagnostics',
    },
  },
  opts = {
    finder = {
      max_height = 0.5,
      min_width = 30,
      force_max_height = false,
      keys = {
        jump_to = 'p',
        expand_or_jump = 'l',
        vsplit = 'v',
        split = 's',
        tabe = 't',
        tabnew = 'r',
        quit = { 'q', '<ESC>' },
        close_in_preview = '<ESC>',
      },
    },
    code_action = {
      num_shortcut = true,
      show_server_name = false,
      extend_gitsigns = true,
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
      title = true,
      border = config.border_style,
      winblend = 0,
      expand = icons.right_arrow,
      collapse = icons.down_arrow,
      code_action = icons.bulb,
      hover = icons.info,
      kind = {},
    },
  },
}
