-- THEME
-- require('gruvbox').setup {
--   undercurl = true,
--   underline = true,
--   bold = true,
--   italic = true,
--   strikethrough = true,
--   invert_selection = false,
--   invert_signs = false,
--   invert_tabline = false,
--   invert_intend_guides = false,
--   inverse = true, -- invert background for search, diffs, statuslines and errors
--   contrast = 'soft', -- can be "hard", "soft" or empty string
--   overrides = {
--     Normal = { bg = 'NONE' },
--     SignColumn = { bg = 'NONE' },
--     NormalFloat = { bg = 'NONE' },
--     FloatBorder = { bg = 'NONE', fg = '#928374' },
--     WhichKeyFloat = { bg = 'NONE' },
--     SpellBad = { fg = '#E06C75', bg = 'NONE' },
--     LightBulbSign = { fg = 'yellow', bg = 'NONE' },
--     WhichKeyBorder = { fg = '#928374' },
--     GitSignsAdd = { bg = 'NONE' },
--     GitSignsChange = { bg = 'NONE' },
--     GitSignsDelete = { bg = 'NONE' },
--     TelescopeBorder = { fg = '#928374' },
--     TelescopePrompt = { bg = 'NONE' },
--     TelescopePromptBorder = { fg = '#928374' },
--     TelescopeResultsBorder = { fg = '#928374' },
--     TelescopePreviewBorder = { fg = '#928374' },
--   },
-- }

local colors = {
  base00 = '#32302f', -- Default Background
  base01 = '#32302f', -- Lighter Background (Used for status bars, line number and folding marks)
  base02 = '#444444', -- Selection Background
  base03 = '#666666', -- Comments, Invisibles, Line Highlighting
  base04 = '#999999', -- Dark Foreground (Used for status bars)
  base05 = '#d4be98', -- Default Foreground, Caret, Delimiters, Operators
  base06 = '#666666', -- Light Foreground (Not often used)
  base07 = '#32302f', -- Light Background (Not often used)
  base08 = '#7daea3', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = '#e78a4e', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = '#ea6962', -- Classes, Markup Bold, Search Text Background
  base0B = '#a9b665', -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = '#d3869b', -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = '#89b482', -- Functions, Methods, Attribute IDs, Headings
  base0E = '#d3869b', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = '#d4be98', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}

local function set_highlights()
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'SpellBad', { fg = colors.base0A })
  vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { fg = colors.base03 })
  vim.api.nvim_set_hl(0, 'TelescopePrompt', { bg = 'NONE' })
end

-- Change neovim + kitty theme
function SetColorscheme(mode)
  vim.cmd('set background=' .. mode)
  vim.loop.spawn('kitty', {
    args = {
      '@',
      'set-colors',
      '-c',
      string.format(vim.env.HOME .. '/.config/kitty/gruvbox-material-soft-' .. mode .. '.conf'),
    },
  }, nil)

  set_highlights()
end

vim.g.gruvbox_dark_sidebar = false
vim.g.gruvbox_dark_float = false
vim.cmd 'colorscheme gruvbox-flat'
set_highlights()
