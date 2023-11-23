-- Load the mini_gruvbox_material colorscheme
vim.cmd 'colorscheme mini_gruvbox_material'

-- Define colors for later use
local colors = {
  gray = '#665c54',
  dark_gray = '#353535',
  green = '#a9b665',
  red = '#ea6962',
  yellow = '#d8a657',
  blue = '#7daea3',
  bg = '#282828',
  fg = '#ddc7a1',
}

-- Define a function to simplify setting a highlight group
local function set_hl(group, options)
  vim.api.nvim_set_hl(0, group, options)
end

-- Set various highlight groups
set_hl('Normal', { bg = 'NONE' })
set_hl('NormalFloat', { bg = 'NONE' })
set_hl('TelescopeBorder', { fg = colors.gray })
set_hl('TelescopeSelection', { bg = colors.dark_gray, fg = colors.fg })
set_hl('TelescopeMatching', { fg = colors.green })
set_hl('FloatBorder', { fg = colors.gray, bg = 'NONE' })
set_hl('NeoTreeCursorLine', { bg = colors.dark_gray, fg = colors.fg })
set_hl('WinSeparator', { bg = 'NONE', fg = colors.gray })
set_hl('WinBar', { bg = 'NONE' })
set_hl('NeotestPassed', { fg = colors.green })
set_hl('NeotestFailed', { fg = colors.red })
set_hl('NeotestTarget', { fg = colors.red })
set_hl('NeotestSkipped', { fg = colors.blue })
set_hl('NeotestRunning', { fg = colors.yellow })
set_hl('NeotestDir', { fg = colors.blue })
set_hl('NeotestFile', { fg = colors.gray })
set_hl('WinBarNC', { fg = colors.gray })
set_hl('WinBar', { fg = colors.fg })
set_hl('IblIndent', { fg = colors.dark_gray })
set_hl('SpellBad', { fg = colors.bg, bg = colors.red })
