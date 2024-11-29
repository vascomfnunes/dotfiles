local config = require 'vasco.config'

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    messages = {
      enabled = true,
      view = nil,
      view_error = 'notify',
      view_warn = nil,
    },
    views = {
      mini = {
        backend = 'mini',
        relative = 'editor',
        align = 'message-right',
        timeout = 2000,
        reverse = true,
        focusable = false,
        position = {
          row = -2,
          col = '100%',
        },
        size = 'auto',
        border = {
          style = config.border.style,
        },
        zindex = 20,
        win_options = {
          winblend = 0,
          winhighlight = {
            Normal = 'Normal',
            IncSearch = '',
            Search = '',
          },
        },
      },
    },
    lsp = {
      signature = {
        enabled = true,
      },
      hover = {
        enabled = false,
      },
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    routes = {
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'written',
        },
        opts = { skip = true },
      },
    },
  },
}
