return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('kanagawa').setup {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = true,
      dimInactive = false,
      terminalColors = true,
      theme = 'dragon', -- "wave", "dragon" or "lotus"
      background = {
        dark = 'dragon',
        light = 'lotus',
      },
      colors = {
        theme = {
          all = {
            ui = {
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
        vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'PmenuBorder', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none' })
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
      end,
    })
  end,
}
