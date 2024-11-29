local wezterm = require 'wezterm'
local action = wezterm.action

local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
  Left = 'h',
  Down = 'j',
  Up = 'k',
  Right = 'l',
  -- reverse lookup
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

return {
  -- move between split panes
  split_nav('move', 'h'),
  split_nav('move', 'j'),
  split_nav('move', 'k'),
  split_nav('move', 'l'),
  -- resize panes
  split_nav('resize', 'h'),
  split_nav('resize', 'j'),
  split_nav('resize', 'k'),
  split_nav('resize', 'l'),
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
  { key = 'H', mods = 'LEADER', action = action { MoveTabRelative = -1 } },
  { key = 'L', mods = 'LEADER', action = action { MoveTabRelative = 1 } },
  { key = 'h', mods = 'LEADER', action = action { ActivateTabRelative = -1 } },
  { key = 'l', mods = 'LEADER', action = action { ActivateTabRelative = 1 } },
  { key = 'a', mods = 'LEADER', action = 'ActivateLastTab' },
  { key = 'u', mods = 'SUPER', action = action { ScrollByPage = -1 } },
  { key = 'd', mods = 'SUPER', action = action { ScrollByPage = 1 } },
  { key = '0', mods = 'SUPER', action = 'ResetFontSize' },
  { key = '-', mods = 'SUPER', action = 'DecreaseFontSize' },
  { key = '=', mods = 'SUPER', action = 'IncreaseFontSize' },
  { key = 'z', mods = 'LEADER', action = 'TogglePaneZoomState' },
  { key = 'c', mods = 'LEADER', action = action { SpawnTab = 'CurrentPaneDomain' } },
  { key = 'q', mods = 'LEADER', action = action { CloseCurrentPane = { confirm = true } } },
  { key = ' ', mods = 'LEADER', action = 'QuickSelect' },
  { key = 'f', mods = 'SUPER', action = 'ToggleFullScreen' },
  { key = '1', mods = 'SUPER', action = action { ActivateTab = 0 } },
  { key = '2', mods = 'SUPER', action = action { ActivateTab = 1 } },
  { key = '3', mods = 'SUPER', action = action { ActivateTab = 2 } },
  { key = '4', mods = 'SUPER', action = action { ActivateTab = 3 } },
  { key = '5', mods = 'SUPER', action = action { ActivateTab = 4 } },
  { key = '6', mods = 'SUPER', action = action { ActivateTab = 5 } },
  { key = '7', mods = 'SUPER', action = action { ActivateTab = 6 } },
  { key = '8', mods = 'SUPER', action = action { ActivateTab = 7 } },
  { key = '9', mods = 'SUPER', action = action { ActivateTab = 8 } },
  { key = '1', mods = 'LEADER', action = action { ActivateTab = 0 } },
  { key = '2', mods = 'LEADER', action = action { ActivateTab = 1 } },
  { key = '3', mods = 'LEADER', action = action { ActivateTab = 2 } },
  { key = '4', mods = 'LEADER', action = action { ActivateTab = 3 } },
  { key = '5', mods = 'LEADER', action = action { ActivateTab = 4 } },
  { key = '6', mods = 'LEADER', action = action { ActivateTab = 5 } },
  { key = '7', mods = 'LEADER', action = action { ActivateTab = 6 } },
  { key = '8', mods = 'LEADER', action = action { ActivateTab = 7 } },
  { key = '9', mods = 'LEADER', action = action { ActivateTab = 8 } },
  { key = 'c', mods = 'SUPER', action = action { CopyTo = 'Clipboard' } },
  { key = 'v', mods = 'SUPER', action = action { PasteFrom = 'Clipboard' } },
  { key = 'w', mods = 'LEADER', action = wezterm.action.ShowTabNavigator },
  { key = 'q', mods = 'SUPER|ALT', action = wezterm.action.QuitApplication },
  -- search
  { key = '/', mods = 'LEADER', action = action.Search 'CurrentSelectionOrEmptyString' },
  {
    key = 'n',
    mods = 'LEADER',
    action = action.Multiple {
      action.CopyMode 'NextMatch',
      action.CopyMode 'ClearSelectionMode',
    },
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = action.Multiple {
      action.CopyMode 'PriorMatch',
      action.CopyMode 'ClearSelectionMode',
    },
  },
}
