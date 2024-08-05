local wezterm = require 'wezterm'

local dark_theme = 'Gruvbox dark, medium (base16)'
local light_theme = 'Gruvbox light, medium (base16)'

local M = {}

M.theme = {
  config = {
    colors = wezterm.color.get_builtin_schemes()[dark_theme],
  },

  for_appearance = function(appearance)
    if appearance:find 'Dark' then
      return dark_theme
    else
      return light_theme
    end
  end,
}

return M
