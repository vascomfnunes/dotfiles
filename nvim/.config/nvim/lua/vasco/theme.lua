-- THEME
require('gruvbox').setup {
  undercurl = true,
  underline = true,
  bold = true,
  italic = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = 'soft', -- can be "hard", "soft" or empty string
  overrides = {
    Normal = { bg = 'NONE' },
    SignColumn = { bg = 'NONE' },
    NormalFloat = { bg = 'NONE' },
    FloatBorder = { bg = 'NONE', fg = '#928374' },
    WhichKeyFloat = { bg = 'NONE' },
    SpellBad = { fg = '#E06C75', bg = 'NONE' },
    LightBulbSign = { fg = 'yellow', bg = 'NONE' },
    WhichKeyBorder = { fg = '#928374' },
    GitSignsAdd = { bg = 'NONE' },
    GitSignsChange = { bg = 'NONE' },
    GitSignsDelete = { bg = 'NONE' },
    TelescopeBorder = { fg = '#928374' },
    TelescopePrompt = { bg = 'NONE' },
    TelescopePromptBorder = { fg = '#928374' },
    TelescopeResultsBorder = { fg = '#928374' },
    TelescopePreviewBorder = { fg = '#928374' },
  },
}

vim.cmd 'colorscheme gruvbox'

-- Change neovim + kitty theme
function SetColorscheme(mode)
  vim.cmd('set background=' .. mode)
  vim.loop.spawn('kitty', {
    args = {
      '@',
      'set-colors',
      '-c',
      string.format(vim.env.HOME .. '/.config/kitty/gruvbox-' .. mode .. '.conf'),
    },
  }, nil)
  -- set_highlights()
end
