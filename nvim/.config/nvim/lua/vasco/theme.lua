local colors = require 'vasco.helpers.colors'

vim.o.termguicolors = true
vim.o.background = 'dark'

vim.cmd [[colorscheme onedark]]

vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'WinBar', { fg = colors.yellow })
vim.api.nvim_set_hl(0, 'WinBarNC', { fg = colors.dark_grey })
vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE', fg = colors.light_grey })
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = colors.grey })
vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = colors.grey })
vim.api.nvim_set_hl(0, 'NeotestPassed', { fg = colors.green })
vim.api.nvim_set_hl(0, 'NeotestFailed', { fg = colors.red })
vim.api.nvim_set_hl(0, 'NeotestTarget', { fg = colors.red })
vim.api.nvim_set_hl(0, 'NeotestSkipped', { fg = colors.blue })
vim.api.nvim_set_hl(0, 'NeotestRunning', { fg = colors.yellow })
vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { fg = colors.dark_grey })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingError', { bg = 'NONE', fg = colors.red })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingWarning', { bg = 'NONE', fg = colors.yellow })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingHint', { bg = 'NONE', fg = colors.green })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingInfo', { bg = 'NONE', fg = colors.blue })
vim.api.nvim_set_hl(0, 'markdownH1', { bg = 'NONE', fg = colors.yellow, bold = true })
vim.api.nvim_set_hl(0, 'markdownH2', { bg = 'NONE', fg = colors.green, bold = true })
vim.api.nvim_set_hl(0, 'markdownH3', { bg = 'NONE', fg = colors.blue, bold = true })
vim.api.nvim_set_hl(0, 'markdownH4', { bg = 'NONE', fg = colors.red, bold = true })
