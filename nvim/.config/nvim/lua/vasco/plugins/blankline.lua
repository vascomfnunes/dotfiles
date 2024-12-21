local config = require 'vasco.config'

return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = 'VeryLazy',
  opts = function()
    local hooks = require 'ibl.hooks'
    -- Set the highlight when the plugin loads
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, 'IblIndent', { fg = config.indent.color })
    end)

    return {
      indent = {
        char = config.indent.char,
        tab_char = config.indent.tab_char,
        highlight = config.indent.highlight,
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          'help',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
        },
      },
    }
  end,
}
