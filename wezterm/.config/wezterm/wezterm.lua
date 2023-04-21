local wezterm = require 'wezterm'
local colorscheme = require 'colorscheme'
local keys = require 'keybindings'

local colors = colorscheme.theme.config.colors
local fonts = wezterm.nerdfonts
local battery = require 'battery'
local mpd = require 'mpd'

local function separator()
  return { Text = '    ' }
end

local function get_date()
  return fonts.fa_clock_o .. '  ' .. wezterm.strftime '%A, %-d %B  %I:%M %p  '
end

return {
  color_scheme = colorscheme.theme.for_appearance(wezterm.gui.get_appearance()),
  font = wezterm.font {
    family = 'JetBrains Mono',
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  },
  font_size = 15.0,
  line_height = 1.2,
  window_decorations = 'RESIZE',
  bold_brightens_ansi_colors = false,
  status_update_interval = 1000,
  exit_behavior = 'CloseOnCleanExit',
  disable_default_key_bindings = true,
  use_ime = true,
  adjust_window_size_when_changing_font_size = false,
  show_tab_index_in_tab_bar = true,
  window_background_opacity = 1.0,
  window_padding = {
    left = 8,
    bottom = 0,
    right = 2,
    top = 8,
  },
  macos_window_background_blur = 20,
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = false,
  use_fancy_tab_bar = true,
  check_for_updates = false,
  colors = {
    tab_bar = {
      -- background = colors.background,
      active_tab = {
        bg_color = colors.background,
        fg_color = colors.ansi[4],
      },
      -- inactive_tab = {
      --   bg_color = colors.background,
      --   fg_color = '#777',
      -- },
    },
  },
  inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 0.7,
  },
  window_frame = {
    font_size = 13.0,
  },
  leader = { key = 'a', mods = 'CTRL' },
  keys = keys,
  wezterm.on('update-right-status', function(window, _)
    window:set_right_status(wezterm.format {
      { Foreground = { Color = colors.ansi[6] } },
      { Text = mpd.now_playing() },
      separator(),
      { Foreground = { Color = battery.color() } },
      { Text = battery.get() },
      separator(),
      { Foreground = { Color = colors.ansi[5] } },
      { Text = get_date() },
    })
  end),
}
