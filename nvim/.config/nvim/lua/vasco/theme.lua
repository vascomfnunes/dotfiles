vim.o.termguicolors = true
vim.o.background = 'dark'
vim.cmd('colorscheme base16-tomorrow-night-eighties')

local colors = require 'vasco.helpers.colors'.theme_dark

vim.api.nvim_set_hl(0, 'SpellBad', { fg = colors.base0A })
vim.api.nvim_set_hl(0, 'NVimTreeWindowPicker', { bg = colors.base08, fg = colors.base05 })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = colors.base02 })
vim.api.nvim_set_hl(0, 'CocFloating', { bg = 'NONE', fg = colors.base02 })
vim.api.nvim_set_hl(0, 'TelescopePrompt', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TelescopePromptPrefix', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TelescopePrompt', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TelescopePromptCounter', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { fg = colors.base0D })
vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = colors.base0D })
vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { fg = colors.base0D })
vim.api.nvim_set_hl(0, 'WinBar', { fg = colors.base09 })
vim.api.nvim_set_hl(0, 'WinBarNC', { fg = colors.base02 })
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = colors.base02 })
vim.api.nvim_set_hl(0, 'CocFloating', { bg = 'NONE' })
