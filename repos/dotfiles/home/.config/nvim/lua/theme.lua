local M = {}
local cmd = vim.cmd
local o = vim.o
local api = vim.api

local function set_theme(theme)
  cmd('colorscheme ' .. theme)
end

local function set_options()
  o.termguicolors = true
  o.background = 'dark'
end

local function set_background_toggle_keymaps()
  api.nvim_set_keymap('n', '<leader>bd', ':set background=dark<CR>', {noremap = true, silent = true})
  api.nvim_set_keymap('n', '<leader>bl', ':set background=light<CR>', {noremap = true, silent = true})
end

function M.init()
  set_theme('vimbox')
  set_options()
  set_background_toggle_keymaps()
end

return M
