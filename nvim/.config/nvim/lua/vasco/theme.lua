vim.cmd [[colorscheme mini_gruvbox_material]]

local gray = '#665c54'

vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = gray })
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = gray, bg = 'NONE' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { bg = gray })
vim.api.nvim_set_hl(0, 'WinSeparator', { bg = 'NONE', fg = gray })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = gray })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = gray })
vim.api.nvim_set_hl(0, 'WinBar', { bg = 'NONE', fg = '#bd6f3e' })
