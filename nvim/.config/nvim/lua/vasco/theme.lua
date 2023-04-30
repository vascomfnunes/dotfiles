local colors = require 'vasco.helpers.colors'

vim.o.termguicolors = true

vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
vim.g.gruvbox_material_spell_foreground = 'colored'
vim.g.gruvbox_material_transparent_background = 2

local function set_highlights(highlights)
  for i, highlight in pairs(highlights) do
    vim.api.nvim_set_hl(0, i, highlight)
  end
end

local M = {}

M.set_dark_colors = function()
  vim.o.background = 'dark'

  local highlights = {
    NormalFloat = { bg = 'NONE' },
    PmenuSel = { bg = colors.dark.grey, fg = colors.dark.fg },
    TelescopeNormal = { bg = 'NONE', fg = colors.dark.grey },
    TelescopeBorder = { fg = colors.dark.grey },
    TelescopeTitle = { fg = colors.dark.blue },
    TelescopePromptTitle = { fg = colors.dark.blue },
    TelescopePromptNormal = { bg = colors.dark.dark_grey },
    TelescopeResultsTitle = { fg = colors.dark.blue },
    TelescopePromptPrefix = { fg = colors.dark.blue },
    TelescopeSelection = { bg = colors.dark.grey, fg = colors.dark.fg },
    TelescopeMatching = { fg = colors.dark.green },
    WhichKeyFloat = { bg = 'NONE' },
    WinBar = { fg = colors.dark.green },
    WinBarNC = { fg = colors.dark.dark_grey },
    Normal = { bg = 'NONE', fg = colors.dark.light_grey },
    FloatBorder = { fg = colors.dark.grey },
    NeotestPassed = { fg = colors.dark.green },
    NeotestFailed = { fg = colors.dark.red },
    NeotestTarget = { fg = colors.dark.red },
    NeotestSkipped = { fg = colors.dark.blue },
    NeotestRunning = { fg = colors.dark.yellow },
    NeotestDir = { fg = colors.dark.yellow },
    NeotestFile = { fg = colors.dark.light_grey },
    NoiceCmdlinePopupBorderCmdline = { fg = colors.dark.grey },
    IndentBlanklineChar = { fg = colors.dark.dark_grey },
    NeoTreeIndentMarker = { fg = colors.dark.dark_grey },
    NeoTreeDirectoryIcon = { fg = colors.dark.blue },
    NeoTreeCursorLine = { bg = colors.dark.grey, fg = colors.dark.fg },
    DiagnosticFloatingError = { bg = 'NONE', fg = colors.dark.red },
    DiagnosticFloatingWarning = { bg = 'NONE', fg = colors.dark.yellow },
    DiagnosticFloatingHint = { bg = 'NONE', fg = colors.dark.green },
    DiagnosticFloatingInfo = { bg = 'NONE', fg = colors.dark.blue },
    DiffChange = { bg = colors.dark.green, fg = colors.dark.bg },
    DiffDelete = { bg = colors.dark.red, fg = colors.dark.bg },
    DiffAdd = { bg = colors.dark.yellow, fg = colors.dark.bg },
    NeoTreeTabActive = { bg = colors.dark.green, fg = colors.dark.bg },
    NeoTreeTabInactive = { bg = colors.dark.dark_grey, fg = colors.dark.fg },
    NeoTreeTabSeparatorInactive = { bg = colors.dark.bg, fg = colors.dark.bg },
    NeoTreeTabSeparatorActive = { bg = colors.dark.bg, fg = colors.dark.bg },
    MDCodeBlock = { bg = '#222222' },
  }

  set_highlights(highlights)
end

M.set_light_colors = function()
  vim.o.background = 'light'

  local highlights = {
    NormalFloat = { bg = 'NONE' },
    TelescopeNormal = { bg = 'NONE', fg = colors.light.grey },
    TelescopeBorder = { fg = colors.light.light_grey },
    TelescopeTitle = { fg = colors.light.blue },
    TelescopePromtpTitle = { fg = colors.light.blue },
    TelescopePromptNormal = { bg = colors.light.fg },
    TelescopeResultsTitle = { fg = colors.light.blue },
    TelescopePromptPrefix = { fg = colors.light.blue },
    TelescopeSelection = { bg = colors.light.fg, fg = colors.light.bg },
    TelescopeMatching = { bg = colors.light.green, fg = colors.light.bg },
    WhichKeyFloat = { bg = 'NONE' },
    WinBar = { fg = colors.light.green },
    WinBarNC = { fg = colors.light.dark_grey },
    Normal = { bg = 'NONE', fg = colors.light.light_grey },
    FloatBorder = { fg = colors.light.light_grey },
    NeotestPassed = { fg = colors.light.green },
    NeotestFailed = { fg = colors.light.red },
    NeotestTarget = { fg = colors.light.red },
    NeotestSkipped = { fg = colors.light.blue },
    NeotestRunning = { fg = colors.light.yellow },
    NeotestDir = { fg = colors.light.yellow },
    NeotestFile = { fg = colors.light.light_grey },
    IndentBlanklineChar = { fg = colors.light.dark_grey },
    NeoTreeIndentMarker = { fg = colors.light.dark_grey },
    NeoTreeDirectoryIcon = { fg = colors.light.yellow },
    DiagnosticFloatingError = { bg = 'NONE', fg = colors.light.red },
    DiagnosticFloatingWarning = { bg = 'NONE', fg = colors.light.yellow },
    DiagnosticFloatingHint = { bg = 'NONE', fg = colors.light.green },
    DiagnosticFloatingInfo = { bg = 'NONE', fg = colors.light.blue },
    DiffChange = { bg = colors.light.green, fg = colors.light.bg },
    DiffDelete = { bg = colors.light.red, fg = colors.light.bg },
    DiffAdd = { bg = colors.light.yellow, fg = colors.light.bg },
  }

  set_highlights(highlights)
end

vim.cmd [[colorscheme gruvbox-material]]

M.set_dark_colors()

return M
