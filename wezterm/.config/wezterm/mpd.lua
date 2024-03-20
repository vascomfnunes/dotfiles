local wezterm = require 'wezterm'
local fonts = wezterm.nerdfonts
local module = {}

local function remove_empty_lines(text)
  return text:gsub('\r?\n', '')
end

module.now_playing = function()
  -- gets current playing track on mpd via mpc
  local success, data, _ = wezterm.run_child_process {
    '/opt/homebrew/bin/mpc',
    'current',
    '-f',
    '%artist% - %title%',
  }

  if success then
    data = remove_empty_lines(string.lower(data))

    if string.len(data) ~= 0 then
      return fonts.fa_music .. ' ' .. string.gsub(' ' .. data, '%W%l', string.upper):sub(4)
    end

    return fonts.fa_pause .. '  MPD Paused'
  end

  return 'no mpd data'
end

return module
