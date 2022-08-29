-- THEME
vim.cmd 'colorscheme onenord'

-- HIGHLIGHTS
local function set_highlights()
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE', fg = '#81A1C1' })
  vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'SpellBad', { bg = '#E06C75' })
end

-- Change neovim + kitty theme
function SetColorscheme(mode)
  vim.cmd('set background=' .. mode)
  vim.loop.spawn('kitty', {
    args = {
      '@',
      'set-colors',
      '-c',
      string.format(vim.env.HOME .. '/.config/kitty/onenord-' .. mode .. '.conf'),
    },
  }, nil)
  set_highlights()
end

set_highlights()
