-- THEME

local function set_colors(colors)
  vim.api.nvim_set_hl(0, 'Pmenu', { bg = colors.base00, fg = colors.base03 })
  vim.api.nvim_set_hl(0, 'Title', { fg = colors.base03 })
  vim.api.nvim_set_hl(0, 'SpellBad', { fg = colors.base0A })
  vim.api.nvim_set_hl(0, 'CmpItemAbbr', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = colors.base0B })
  vim.api.nvim_set_hl(0, 'CmpItemKind', { fg = colors.base0A })
  vim.api.nvim_set_hl(0, 'CmpItemKindSnippet', { fg = colors.base08 })
  vim.api.nvim_set_hl(0, 'FloatTitle', { fg = colors.base05 })
  vim.api.nvim_set_hl(0, 'NVimTreeWindowPicker', { bg = colors.base03, fg = colors.base05 })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = colors.base04 })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE', fg = colors.base02 })
  vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { fg = colors.base02 })
  vim.api.nvim_set_hl(0, 'TelescopePrompt', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = colors.base02 })
  vim.api.nvim_set_hl(0, 'TelescopePromptPrefix', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopePrompt', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopePromptCounter', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = colors.base02 })
  vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = colors.base02 })
  vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { fg = colors.base0D })
  vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = colors.base0D })
  vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { fg = colors.base0D })
  vim.api.nvim_set_hl(0, 'WinBar', { bg = colors.base02 })
  vim.api.nvim_set_hl(0, 'WinBarNC', { fg = colors.base02 })
  vim.api.nvim_set_hl(0, 'WinSeparator', { fg = colors.base02 })
  vim.api.nvim_set_hl(0, 'SjLabel', { bg = colors.base08, fg = colors.base00 })
  vim.api.nvim_set_hl(0, 'SjMatches', { bg = colors.base02, fg = colors.base00 })
end

local function set_highlights_dark()
  set_colors(require('colors').theme_dark)
end

local function set_highlights_light()
  set_colors(require('colors').theme_light)
end

-- Change neovim + kitty theme
function SetColorscheme(mode)
  vim.loop.spawn('kitty', {
    args = {
      '@',
      'set-colors',
      '-c',
      string.format(vim.env.HOME .. '/.config/kitty/tomorrow-' .. mode .. '.conf'),
    },
  }, nil)

  if mode == 'dark' then
    vim.cmd 'colorscheme base16-tomorrow-night-eighties'
    set_highlights_dark()
  else
    vim.cmd 'colorscheme base16-tomorrow'
    set_highlights_light()
  end
end

vim.cmd [[colorscheme base16-tomorrow-night-eighties ]]
set_highlights_dark()
