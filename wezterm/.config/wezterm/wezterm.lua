local wezterm = require 'wezterm'
local fonts = wezterm.nerdfonts
local colorscheme = require 'colorscheme'
local colors = colorscheme.theme.config.colors
local keys = require 'keybindings'
local battery = require 'battery'
local mpd = require 'mpd'
local startup = require 'startup'

local function separator()
  return { Text = '    ' }
end

local function get_date()
  return fonts.fa_clock_o .. '  ' .. wezterm.strftime '%A, %-d %B  %I:%M %p  '
end

-- Create default panes and tabs
startup.run()

return {
  color_scheme = colorscheme.theme.for_appearance(wezterm.gui.get_appearance()),
  font = wezterm.font {
    family = 'JetBrains Mono',
    weight = 'Medium',
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  },
  font_size = 15.0,
  line_height = 1.3,
  window_decorations = 'RESIZE',
  native_macos_fullscreen_mode = true,
  bold_brightens_ansi_colors = false,
  status_update_interval = 1000,
  exit_behavior = 'CloseOnCleanExit',
  disable_default_key_bindings = true,
  adjust_window_size_when_changing_font_size = false,
  show_tab_index_in_tab_bar = true,
  -- background = {
  --   {
  --     source = {
  --       File = '/image.jpg',
  --     },
  --     hsb = { brightness = 0.1},
  --   },
  -- },
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
        bg_color = colors.ansi[1],
        fg_color = colors.ansi[8],
      },
      inactive_tab = {
        bg_color = colors.background,
        fg_color = colors.ansi[1],
      },
    },
  },
  inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.5,
  },
  window_frame = {
    font_size = 13.0,
    active_titlebar_bg = colors.background,
  },
  leader = { key = 'a', mods = 'CTRL' },
  keys = keys,
  wezterm.on('update-right-status', function(window, _)
    window:set_right_status(wezterm.format {
      { Background = { Color = colors.background } },
      { Foreground = { Color = colors.ansi[6] } },
      { Text = mpd.now_playing() },
      separator(),
      { Background = { Color = colors.background } },
      { Foreground = { Color = battery.color() } },
      { Text = battery.get() },
      separator(),
      { Background = { Color = colors.background } },
      { Foreground = { Color = colors.ansi[5] } },
      { Text = get_date() },
    })
  end),
}
