-- Load the mini_gruvbox_material colorscheme
vim.cmd 'colorscheme mini_gruvbox_material'

-- Define colors for later use
local gray = '#665c54'

-- Define a function to simplify setting a highlight group
local function set_hl(group, options)
  vim.api.nvim_set_hl(0, group, options)
end

-- Set various highlight groups
set_hl('TelescopeBorder', { fg = gray })
set_hl('FloatBorder', { fg = gray, bg = 'NONE' })
set_hl('NormalFloat', { bg = 'NONE' })
set_hl('NeoTreeCursorLine', { bg = gray })
set_hl('WinSeparator', { bg = 'NONE', fg = gray })
set_hl('PmenuSel', { bg = gray })
set_hl('PmenuThumb', { bg = gray })
set_hl('WinBar', { bg = 'NONE' })
