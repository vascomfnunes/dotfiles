local config = require 'vasco.config'

return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = function()
    -- Safe require for hooks
    local ok, hooks = pcall(require, 'ibl.hooks')
    if not ok then
      return {}
    end

    -- Set the highlight when the plugin loads
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, 'IblIndent', { fg = config.indent.color })
    end)

    return {
      indent = {
        char = config.indent.char or '│',
        tab_char = config.indent.tab_char or '│',
        highlight = config.indent.highlight or 'IblIndent',
      },
      scope = {
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          'help',
          'neo-tree',
          'Trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'dashboard',
          'alpha',
          'NvimTree',
          'TelescopePrompt',
          'lspinfo',
          'checkhealth',
          'man',
          'gitcommit',
          'TelescopeResults',
        },
      },
    }
  end,
}
