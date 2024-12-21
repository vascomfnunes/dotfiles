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

    -- Override the highlights immediately after
    local transparent_groups = {
      'NormalFloat',
      'Normal',
      'FloatBorder',
      'Pmenu',
      'PmenuBorder',
      'WhichKeyNormal',
      'LazyNormal',
    }

    -- we need to wait a bit for the colorscheme to be fully loaded
    vim.defer_fn(function()
      for _, group in ipairs(transparent_groups) do
        vim.api.nvim_set_hl(0, group, { bg = 'NONE' })
      end
    end, 100)
  end,
}
