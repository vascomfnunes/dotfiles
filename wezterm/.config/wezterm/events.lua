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

    window:gui_window():perform_action(actions.ActivateTab(0), home_pane)
  end)

  wezterm.on('bell', function(_, pane)
    wezterm.log_info('The bell was rung in pane ' .. pane:pane_id() .. '!')
  end)
end

return M
