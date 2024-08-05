local wezterm = require 'wezterm'
local mux = wezterm.mux
local actions = wezterm.action
local home = wezterm.home_dir
local M = {}

M.run = function()
  wezterm.on('gui-startup', function()
    -- Default pane
    local home_tab, home_pane, window = mux.spawn_window {
      workspace = 'default',
      cwd = home .. '/repos',
    }
    home_tab:set_title 'home'

    -- Repos pane
    local servers_tab, servers_pane = window:spawn_tab {
      cwd = home .. '/servers',
    }
    servers_tab:set_title 'servers'

    local servers_split_pane = servers_pane:split {}
    servers_split_pane:split { direction = 'Bottom' }

    -- Music pane
    local music_tab, music_pane = window:spawn_tab {
      cwd = home,
    }
    music_pane:send_text 'music\n'
    music_tab:set_title 'media'

    -- Newsboat
    local news_tab, news_pane = window:spawn_tab {
      cwd = home,
    }
    news_pane:send_text 'newsboat\n'
    news_tab:set_title 'news'

    window:gui_window():perform_action(actions.ActivateTab(0), home_pane)
  end)

  wezterm.on('bell', function(_, pane)
    wezterm.log_info('The bell was rung in pane ' .. pane:pane_id() .. '!')
  end)
end

return M
