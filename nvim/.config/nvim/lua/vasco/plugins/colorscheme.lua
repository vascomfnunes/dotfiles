return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- Setup for Kanagawa colorscheme with a modern, dark theme inspired by the colors of the Great Wave off Kanagawa
    require('kanagawa').setup {
      compile = true,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = true,
      dimInactive = false,
      terminalColors = true,

      -- Available themes: "wave" (default), "dragon" (warmer), "lotus" (lighter)
      theme = 'wave',
      background = {
        dark = 'wave',
        light = 'lotus',
      },

      -- Theme color configurations
      colors = {
        theme = {
          all = {
            ui = {
              float = { bg = 'none' },
              bg_gutter = 'none',
            },
          },
        },
      },
   }

    vim.cmd.colorscheme 'kanagawa'

    -- Set transparent backgrounds for various UI elements
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        local transparent_groups = {
          'NormalFloat',
          'FloatBorder',
          'Pmenu',
          'PmenuBorder',
          'LazyNormal',
        }

        for _, group in ipairs(transparent_groups) do
          vim.api.nvim_set_hl(0, group, { bg = 'none' })
        end
      end,
    })
  end,
}
