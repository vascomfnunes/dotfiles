local wezterm = require 'wezterm'
local fonts = wezterm.nerdfonts

-- weather
local weather_timestamp = 0
local update_weather = 900 -- 15 minutes
local weather_value = ''

-- cpu
local cpu_value = 0

local colors = {
  fg = '#d4be98',
  bg = '#32302f',
  black = '#5a524c',
  red = '#ea6962',
  green = '#a9b665',
  yellow = '#d8a657',
  blue = '#7daea3',
  purple = '#d3869b',
  cyan = '#89b482',
  white = '#d4be98',
  grey = '#777777',
}

local function separator()
  return { Text = '   |   ' }
end

local function remove_empty_lines(text)
  return text:gsub('\r?\n', '')
end

local function get_date()
  return fonts.fa_clock_o .. '  ' .. wezterm.strftime '%A, %-d %B  %I:%M %p  '
end

-- local function get_volume_icon()
--    local _, data, _ = wezterm.run_child_process({
--       "usr/bin/osascript",
--       "-e",
--       "set ovol to output muted of (get volume settings)",
--    })
--
--    if remove_empty_lines(data) == "true" then
--       return fonts.mdi_volume_mute
--    end
--
--    return fonts.mdi_volume_high
-- end
--
-- local function get_volume()
--    local success, data, err = wezterm.run_child_process({
--       "usr/bin/osascript",
--       "-e",
--       "set ovol to output volume of (get volume settings)",
--    })
--
--    if success then
--       return get_volume_icon() .. "  " .. remove_empty_lines(data) .. "%"
--    end
--
--    return err
-- end

local function get_battery()
  local battery = ''
  local battery_info = wezterm.battery_info()

  if battery_info then
    local icon = ''

    for _, b in ipairs(battery_info) do
      local charge = b.state_of_charge * 100

      if charge <= 10 then
        icon = fonts.mdi_battery_alert
      elseif charge > 10 and charge <= 30 then
        icon = fonts.mdi_battery_20
      elseif charge > 30 and charge <= 50 then
        icon = fonts.mdi_battery_40
      elseif charge > 50 and charge <= 70 then
        icon = fonts.mdi_battery_60
      elseif charge > 70 and charge <= 90 then
        icon = fonts.mdi_battery_80
      else
        icon = fonts.mdi_battery
      end

      battery = icon .. ' ' .. string.format('%.0f%%', charge) .. '%'
    end

    return battery
  end
end

local function read_weather_from_file()
  -- gets contents from text file
  -- that should be run by weather.sh script present in ~/bin/weather.sh
  -- set a cron job to get the weather periodically
  -- the OPEN_WEATHER_API_KEY environment variable should be defined in the crontab file itself
  local handle = io.open(wezterm.home_dir .. '/.weather', 'r')
  local result = handle:read '*a'
  handle:close()
  local weather = remove_empty_lines(result)
  weather_timestamp = os.time()

  if string.len(weather) > 0 then
    return weather
  end

  return '--'
end

local function get_weather()
  -- update weather from file if memory cache is expired
  if (weather_timestamp + update_weather) < os.time() then
    weather_value = read_weather_from_file()
  end

  return weather_value
end

local function get_cpu_color()
  local success, data, _ = wezterm.run_child_process {
    wezterm.home_dir .. '/bin/cpu.sh',
  }

  if success then
    cpu_value = (tonumber(data) + 0.0)

    if cpu_value < 30 then
      return colors.green
    elseif cpu_value < 70 then
      return colors.yellow
    else
      return colors.red
    end
  end

  return colors.red
end

local function get_battery_color()
  local battery_info = wezterm.battery_info()
  for _, b in ipairs(battery_info) do
    local charge = b.state_of_charge * 100

    if charge <= 10 then
      return colors.red
    elseif charge < 40 then
      return colors.yellow
    end

    return colors.green
  end
end

local function get_mpd()
  -- gets current playing track on mpd via mpc
  local success, data, _ = wezterm.run_child_process {
    '/usr/local/bin/mpc',
    'current',
    '-f',
    '%artist% - %title%',
  }

  if success then
    data = remove_empty_lines(string.lower(data))

    if string.len(data) ~= 0 then
      return fonts.mdi_music .. '  ' .. string.gsub(' ' .. data, '%W%l', string.upper):sub(2)
    end

    return ''
  end

  return 'no mpd data'
end

return {
  check_for_updates = false,

  font = wezterm.font {
    -- JetBrains Mono is bundled by wezterm itself
    family = 'JetBrains Mono',
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  },
  font_size = 15.0,
  line_height = 1.2,
  window_decorations = 'RESIZE',
  bold_brightens_ansi_colors = false,
  status_update_interval = 1000,
  exit_behavior = 'Close',
  adjust_window_size_when_changing_font_size = false,
  show_tab_index_in_tab_bar = true,
  window_background_opacity = 0.95,
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = false,
  use_fancy_tab_bar = true,

  -- Gruvbox material dark soft
  colors = {
    foreground = colors.fg,
    background = colors.bg,
    cursor_bg = colors.fg,
    cursor_fg = colors.bg,
    selection_fg = colors.bg,
    selection_bg = colors.fg,
    split = colors.black,

    ansi = {
      colors.black,
      colors.red,
      colors.green,
      colors.yellow,
      colors.blue,
      colors.purple,
      colors.cyan,
      colors.white,
    },
    brights = {
      colors.black,
      colors.red,
      colors.green,
      colors.yellow,
      colors.blue,
      colors.purple,
      colors.cyan,
      colors.white,
    },
    tab_bar = {
      active_tab = {
        bg_color = colors.green,
        fg_color = colors.black,
      },
    },
  },
  window_frame = {
    font_size = 13.0,
  },

  wezterm.on('update-right-status', function(window, _)
    window:set_right_status(wezterm.format {
      { Foreground = { Color = colors.blue } },
      { Text = get_mpd() },
      { Foreground = { Color = colors.black } },
      -- separator(),
      -- { Foreground = { Color = get_cpu_color() } },
      -- { Text = fonts.mdi_memory .. "  " .. string.format("%02.0f%%", cpu_value) },
      -- { Foreground = { Color = colors.black } },
      separator(),
      { Foreground = { Color = get_battery_color() } },
      { Text = get_battery() },
      { Foreground = { Color = colors.black } },
      -- separator(),
      -- { Foreground = { Color = colors.grey } },
      -- { Text = get_volume() },
      -- { Foreground = { Color = colors.black } },
      separator(),
      { Foreground = { Color = colors.grey } },
      { Text = string.format('%s°C', get_weather()) },
      { Foreground = { Color = colors.black } },
      separator(),
      { Foreground = { Color = colors.grey } },
      { Text = get_date() },
    })
  end),

  -- key mappings
  leader = { key = 'a', mods = 'CTRL' },
  keys = {
    {
      key = 's',
      mods = 'LEADER',
      action = wezterm.action { SplitVertical = { domain = 'CurrentPaneDomain' } },
    },
    {
      key = 'v',
      mods = 'LEADER',
      action = wezterm.action { SplitHorizontal = { domain = 'CurrentPaneDomain' } },
    },
    {
      key = 'Enter',
      mods = 'SUPER',
      action = wezterm.action { SplitHorizontal = { domain = 'CurrentPaneDomain' } },
    },
    { key = 'w', mods = 'LEADER', action = 'ShowTabNavigator' },
    { key = ']', mods = 'SUPER', action = wezterm.action { ActivateTabRelative = -1 } },
    { key = '[', mods = 'SUPER', action = wezterm.action { ActivateTabRelative = 1 } },
    { key = '[', mods = 'SUPER|SHIFT', action = wezterm.action { MoveTabRelative = -1 } },
    { key = ']', mods = 'SUPER|SHIFT', action = wezterm.action { MoveTabRelative = 1 } },
    { key = 'u', mods = 'SUPER', action = wezterm.action { ScrollByPage = -1 } },
    { key = 'd', mods = 'SUPER', action = wezterm.action { ScrollByPage = 1 } },
    { key = 'l', mods = 'SUPER', action = wezterm.action { ActivatePaneDirection = 'Right' } },
    { key = 'h', mods = 'SUPER', action = wezterm.action { ActivatePaneDirection = 'Left' } },
    { key = 'k', mods = 'SUPER', action = wezterm.action { ActivatePaneDirection = 'Up' } },
    { key = '[', mods = 'SUPER', action = wezterm.action { ActivateTabRelative = 1 } },
    { key = '[', mods = 'SUPER|SHIFT', action = wezterm.action { MoveTabRelative = -1 } },
    { key = ']', mods = 'SUPER|SHIFT', action = wezterm.action { MoveTabRelative = 1 } },
    { key = 'u', mods = 'SUPER', action = wezterm.action { ScrollByPage = -1 } },
    { key = 'd', mods = 'SUPER', action = wezterm.action { ScrollByPage = 1 } },
    { key = 'l', mods = 'SUPER', action = wezterm.action { ActivatePaneDirection = 'Right' } },
    { key = 'h', mods = 'SUPER', action = wezterm.action { ActivatePaneDirection = 'Left' } },
    { key = 'k', mods = 'SUPER', action = wezterm.action { ActivatePaneDirection = 'Up' } },
    { key = 'j', mods = 'SUPER', action = wezterm.action { ActivatePaneDirection = 'Down' } },
    { key = '0', mods = 'SUPER', action = 'ResetFontSize' },
    { key = '-', mods = 'SUPER', action = 'DecreaseFontSize' },
    { key = '=', mods = 'SUPER', action = 'IncreaseFontSize' },
    { key = 'z', mods = 'SUPER', action = 'TogglePaneZoomState' },
    { key = 't', mods = 'SUPER', action = wezterm.action { SpawnTab = 'CurrentPaneDomain' } },
    { key = 'W', mods = 'SUPER', action = wezterm.action { CloseCurrentTab = { confirm = true } } },
    { key = 'w', mods = 'SUPER', action = wezterm.action { CloseCurrentPane = { confirm = true } } },
    { key = ' ', mods = 'LEADER', action = 'QuickSelect' },
    { key = 'f', mods = 'SUPER', action = 'ToggleFullScreen' },
    { key = 'h', mods = 'SUPER|ALT', action = wezterm.action { AdjustPaneSize = { 'Left', 5 } } },
    { key = 'j', mods = 'SUPER|ALT', action = wezterm.action { AdjustPaneSize = { 'Down', 5 } } },
    { key = 'k', mods = 'SUPER|ALT', action = wezterm.action { AdjustPaneSize = { 'Up', 5 } } },
    { key = 'l', mods = 'SUPER|ALT', action = wezterm.action { AdjustPaneSize = { 'Right', 5 } } },
  },
}
