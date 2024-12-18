return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  config = function()
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
      theme = 'wave', -- "wave", "dragon" or "lotus"
      background = {
        dark = 'wave',
        light = 'lotus',
      },
      colors = {
        theme = {
          all = {
            ui = {
              float = {
                bg = 'none',
              },
              bg_gutter = 'none',
            },
          },
        },
      },
    }

    vim.cmd.colorscheme 'kanagawa'

    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'PmenuBorder', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'CmpBorder', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'CmpDocBorder', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'CmpFloatBorder', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'WhichKeyBorder', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'WhichKey', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'WhichKeyGroup', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'WhichKeySeparator', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'WhichKeyDesc', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'WhichKeyValue', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'LazyNormal', { bg = 'none' })
      end,
    })
  end,
}
