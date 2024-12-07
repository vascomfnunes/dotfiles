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
      overrides = function(colors)
        local theme = colors.theme
        local makeDiagnosticColor = function(color)
          local c = require 'kanagawa.lib.color'
          return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
        end
        return {
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
          DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
          DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
          DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
          DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
        }
      end,
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
