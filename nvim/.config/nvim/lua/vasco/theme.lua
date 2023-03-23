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

function Dark()
  vim.o.background = 'dark'

  local highlights = {
    NormalFloat = { bg = 'NONE' },
    PmenuSel = { bg = colors.grey, fg = colors.fg },
    TelescopeNormal = { bg = 'NONE', fg = colors.grey },
    TelescopeBorder = { fg = colors.grey },
    TelescopeTitle = { fg = colors.blue },
    TelescopePromptTitle = { fg = colors.blue },
    TelescopePromptNormal = { bg = colors.dark_grey },
    TelescopeResultsTitle = { fg = colors.blue },
    TelescopePromptPrefix = { fg = colors.blue },
    TelescopeSelection = { bg = colors.grey, fg = colors.fg },
    TelescopeMatching = { fg = colors.green },
    WhichKeyFloat = { bg = 'NONE' },
    WinBar = { fg = colors.green },
    WinBarNC = { fg = colors.dark_grey },
    Normal = { bg = 'NONE', fg = colors.light_grey },
    FloatBorder = { fg = colors.grey },
    NeotestPassed = { fg = colors.green },
    NeotestFailed = { fg = colors.red },
    NeotestTarget = { fg = colors.red },
    NeotestSkipped = { fg = colors.blue },
    NeotestRunning = { fg = colors.yellow },
    NeotestDir = { fg = colors.yellow },
    NeotestFile = { fg = colors.light_grey },
    NoiceCmdlinePopupBorderCmdline = { fg = colors.grey },
    IndentBlanklineChar = { fg = colors.dark_grey },
    NeoTreeIndentMarker = { fg = colors.dark_grey },
    NeoTreeDirectoryIcon = { fg = colors.blue },
    NeoTreeCursorLine = { bg = colors.grey, fg = colors.fg },
    DiagnosticFloatingError = { bg = 'NONE', fg = colors.red },
    DiagnosticFloatingWarning = { bg = 'NONE', fg = colors.yellow },
    DiagnosticFloatingHint = { bg = 'NONE', fg = colors.green },
    DiagnosticFloatingInfo = { bg = 'NONE', fg = colors.blue },
    DiffChange = { bg = colors.green, fg = colors.bg },
    DiffDelete = { bg = colors.red, fg = colors.bg },
    DiffAdd = { bg = colors.yellow, fg = colors.bg },
    NeoTreeTabActive = { bg = colors.green, fg = colors.bg },
    NeoTreeTabInactive = { bg = colors.dark_grey, fg = colors.fg },
    NeoTreeTabSeparatorInactive = { bg = colors.bg, fg = colors.bg },
    NeoTreeTabSeparatorActive = { bg = colors.bg, fg = colors.bg },
  }

  set_highlights(highlights)
end

function Light()
  vim.o.background = 'light'

  local light_colors = {
    bg = '#fbf1c7',
    fg = '#654735',
    red = '#c14a4a',
    yellow = '#b47109',
    green = '#6c782e',
    dark_grey = '#32302F',
    light_grey = '#665c54',
    blue = '#45707a',
    grey = '#5a524c',
    purple = '#945e80',
    orange = '#e78a4e',
  }

  local highlights = {
    NormalFloat = { bg = 'NONE' },
    TelescopeNormal = { bg = 'NONE', fg = light_colors.grey },
    TelescopeBorder = { fg = light_colors.light_grey },
    TelescopeTitle = { fg = light_colors.blue },
    TelescopePromtpTitle = { fg = light_colors.blue },
    TelescopePromptNormal = { bg = light_colors.fg },
    TelescopeResultsTitle = { fg = light_colors.blue },
    TelescopePromptPrefix = { fg = light_colors.blue },
    TelescopeSelection = { bg = light_colors.fg, fg = light_colors.bg },
    TelescopeMatching = { bg = light_colors.green, fg = light_colors.bg },
    WhichKeyFloat = { bg = 'NONE' },
    WinBar = { fg = light_colors.green },
    WinBarNC = { fg = light_colors.dark_grey },
    Normal = { bg = 'NONE', fg = light_colors.light_grey },
    FloatBorder = { fg = light_colors.light_grey },
    NeotestPassed = { fg = light_colors.green },
    NeotestFailed = { fg = light_colors.red },
    NeotestTarget = { fg = light_colors.red },
    NeotestSkipped = { fg = light_colors.blue },
    NeotestRunning = { fg = light_colors.yellow },
    NeotestDir = { fg = light_colors.yellow },
    NeotestFile = { fg = light_colors.light_grey },
    IndentBlanklineChar = { fg = light_colors.dark_grey },
    NeoTreeIndentMarker = { fg = light_colors.dark_grey },
    NeoTreeDirectoryIcon = { fg = light_colors.yellow },
    DiagnosticFloatingError = { bg = 'NONE', fg = light_colors.red },
    DiagnosticFloatingWarning = { bg = 'NONE', fg = light_colors.yellow },
    DiagnosticFloatingHint = { bg = 'NONE', fg = light_colors.green },
    DiagnosticFloatingInfo = { bg = 'NONE', fg = light_colors.blue },
    DiffChange = { bg = light_colors.green, fg = light_colors.bg },
    DiffDelete = { bg = light_colors.red, fg = light_colors.bg },
    DiffAdd = { bg = light_colors.yellow, fg = light_colors.bg },
  }

  set_highlights(highlights)
end

vim.cmd [[colorscheme gruvbox-material]]
Dark()
