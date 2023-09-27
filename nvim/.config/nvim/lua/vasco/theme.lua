-- Load the mini_gruvbox_material colorscheme
vim.cmd 'colorscheme mini_gruvbox_material'

-- Define colors for later use
local gray = '#665c54'
local dark_gray = '#353535'
local green = '#a9b665'
local red = '#ea6962'
local yellow = '#d8a657'
local blue = '#7daea3'
local bg = '#282828'
local fg = '#ddc7a1'

-- Define a function to simplify setting a highlight group
local function set_hl(group, options)
  vim.api.nvim_set_hl(0, group, options)
end

-- Set various highlight groups
set_hl('Normal', { bg = 'NONE' })
set_hl('TelescopeBorder', { fg = gray })
set_hl('TelescopeSelection', { bg = fg, fg = bg })
set_hl('TelescopeMatching', { fg = red })
set_hl('FloatBorder', { fg = gray, bg = 'NONE' })
set_hl('NormalFloat', { bg = 'NONE' })
set_hl('NeoTreeCursorLine', { bg = fg, fg = bg })
set_hl('WinSeparator', { bg = 'NONE', fg = gray })
set_hl('WinBar', { bg = 'NONE' })
set_hl('NeotestPassed', { fg = green })
set_hl('NeotestFailed', { fg = red })
set_hl('NeotestTarget', { fg = red })
set_hl('NeotestSkipped', { fg = blue })
set_hl('NeotestRunning', { fg = yellow })
set_hl('NeotestDir', { fg = blue })
set_hl('NeotestFile', { fg = gray })
set_hl('RainbowDelimiterRed', { fg = red })
set_hl('RainbowDelimiterYellow', { fg = yellow })
set_hl('RainbowDelimiterBlue', { fg = blue })
set_hl('RainbowDelimiterOrange', { fg = yellow })
set_hl('RainbowDelimiterGreen', { fg = green })
set_hl('IndentBlankLineChar', { fg = dark_gray })
set_hl('WinBarNC', { fg = gray })
set_hl('WinBar', { fg = fg })
set_hl('BufferLineSeparator', { fg = bg })
