-- THEME

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
  vim.api.nvim_set_hl(0, 'Pmenu', { bg = colors.base02, fg = colors.base03 })
  vim.api.nvim_set_hl(0, 'Title', { fg = colors.base03 })
  vim.api.nvim_set_hl(0, 'SpellBad', { fg = colors.base0A })
  vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = colors.base0B })
  vim.api.nvim_set_hl(0, 'CmpItemKind', { fg = colors.base0A })
  vim.api.nvim_set_hl(0, 'CmpItemKindSnippet', { fg = colors.base08 })
  vim.api.nvim_set_hl(0, 'FloatTitle', { fg = colors.base05 })
  vim.api.nvim_set_hl(0, 'NVimTreeWindowPicker', { bg = colors.base03, fg = colors.base05 })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = colors.base05 })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE', fg = colors.base03 })
  vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = colors.base02 })
  vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { bg = colors.base0A, fg = colors.base00 })
  vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { fg = colors.base02 })
  vim.api.nvim_set_hl(0, 'TelescopePrompt', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = colors.base03 })
  vim.api.nvim_set_hl(0, 'TelescopePromptPrefix', { fg = colors.base03 })
  vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = colors.base03 })
  vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = colors.base03 })
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

vim.g.gruvbox_material_background = 'soft'
vim.g.gruvbox_material_better_performance = 1
vim.cmd [[colorscheme gruvbox-material]]

set_highlights()
