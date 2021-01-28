local M = {}
local o = vim.o
local api = vim.api
local cmd = vim.cmd

local function set_background_toggle_keymaps()
  api.nvim_set_keymap('n', '<leader>bd', ':set background=dark<CR>', {noremap = true, silent = true})
  api.nvim_set_keymap('n', '<leader>bl', ':set background=light<CR>', {noremap = true, silent = true})
end

function M.init()
  cmd('colorscheme vimbox')
  o.termguicolors = true
  set_background_toggle_keymaps()
end

return M
