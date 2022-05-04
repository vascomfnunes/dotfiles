-- TMUX
--

local status_ok, tmux = pcall(require, 'tmux')

if not status_ok then
  return
end

tmux.setup {
  copy_sync = { enable = false },
  navigation = {
    -- enables default keybindings (C-hjkl) for normal mode
    enable_default_keybindings = true,
  },
  resize = {
    -- enables default keybindings (A-hjkl) for normal mode
    enable_default_keybindings = true,
    resize_step_x = 5,
    resize_step_y = 5,
  },
}
