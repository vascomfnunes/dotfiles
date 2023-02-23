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
    TelescopeNormal = { bg = 'NONE' },
    WhichKeyFloat = { bg = 'NONE' },
    NvimTreeNormal = { bg = 'NONE' },
    NvimTreeEndOfBuffer = { bg = 'NONE' },
    WinBar = { fg = colors.yellow },
    WinBarNC = { fg = colors.dark_grey },
    Normal = { bg = 'NONE', fg = colors.light_grey },
    FloatBorder = { fg = colors.grey },
    TelescopeBorder = { fg = colors.grey },
    NeotestPassed = { fg = colors.green },
    NeotestFailed = { fg = colors.red },
    NeotestTarget = { fg = colors.red },
    NeotestSkipped = { fg = colors.blue },
    NeotestRunning = { fg = colors.yellow },
    NeotestDir = { fg = colors.yellow },
    NeotestFile = { fg = colors.light_grey },
    IndentBlanklineChar = { fg = colors.dark_grey },
    NeoTreeIndentMarker = { fg = colors.dark_grey },
    NeoTreeDirectoryIcon = { fg = colors.yellow },
    DiagnosticFloatingError = { bg = 'NONE', fg = colors.red },
    DiagnosticFloatingWarning = { bg = 'NONE', fg = colors.yellow },
    DiagnosticFloatingHint = { bg = 'NONE', fg = colors.green },
    DiagnosticFloatingInfo = { bg = 'NONE', fg = colors.blue },
  }

  set_highlights(highlights)
end

function Light()
  vim.o.background = 'light'

  local highlights = {
    NormalFloat = { bg = 'NONE' },
    TelescopeNormal = { bg = 'NONE' },
    WhichKeyFloat = { bg = 'NONE' },
    NvimTreeNormal = { bg = 'NONE' },
    NvimTreeEndOfBuffer = { bg = 'NONE' },
    WinBar = { fg = colors.yellow },
    WinBarNC = { fg = colors.dark_grey },
    Normal = { bg = 'NONE', fg = colors.light_grey },
    FloatBorder = { fg = colors.grey },
    TelescopeBorder = { fg = colors.grey },
    NeotestPassed = { fg = colors.green },
    NeotestFailed = { fg = colors.red },
    NeotestTarget = { fg = colors.red },
    NeotestSkipped = { fg = colors.blue },
    NeotestRunning = { fg = colors.yellow },
    NeotestDir = { fg = colors.yellow },
    NeotestFile = { fg = colors.light_grey },
    IndentBlanklineChar = { fg = colors.dark_grey },
    NeoTreeIndentMarker = { fg = colors.dark_grey },
    NeoTreeDirectoryIcon = { fg = colors.yellow },
    DiagnosticFloatingError = { bg = 'NONE', fg = colors.red },
    DiagnosticFloatingWarning = { bg = 'NONE', fg = colors.yellow },
    DiagnosticFloatingHint = { bg = 'NONE', fg = colors.green },
    DiagnosticFloatingInfo = { bg = 'NONE', fg = colors.blue },
  }

  set_highlights(highlights)
end

vim.cmd [[colorscheme gruvbox-material]]
Dark()
