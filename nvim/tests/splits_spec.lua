local root = assert(arg[1], "dotfiles root is required")
package.path = root .. "/nvim/lua/?.lua;" .. package.path

local splits = require("splits")
vim.env.TMUX = nil

-- Vertical separator: left | right.

vim.cmd.vsplit()
local left = vim.api.nvim_get_current_win()
vim.cmd.wincmd("l")
local right = vim.api.nvim_get_current_win()

vim.api.nvim_set_current_win(left)
local width = vim.api.nvim_win_get_width(left)
splits.resize("right")
assert(vim.api.nvim_win_get_width(left) == width + 3, "resize right should move the separator right")
splits.resize("left")
assert(vim.api.nvim_win_get_width(left) == width, "resize left should move the separator left")

vim.api.nvim_set_current_win(right)
width = vim.api.nvim_win_get_width(right)
splits.resize("right")
assert(vim.api.nvim_win_get_width(right) == width - 3, "resize right should move the separator right")
splits.resize("left")
assert(vim.api.nvim_win_get_width(right) == width, "resize left should move the separator left")

vim.cmd.only()

-- Horizontal separator: top / bottom.

vim.cmd.split()
local top = vim.api.nvim_get_current_win()
vim.cmd.wincmd("j")
local bottom = vim.api.nvim_get_current_win()

vim.api.nvim_set_current_win(top)
local height = vim.api.nvim_win_get_height(top)
splits.resize("down")
assert(vim.api.nvim_win_get_height(top) == height + 3, "resize down should move the separator down")
splits.resize("up")
assert(vim.api.nvim_win_get_height(top) == height, "resize up should move the separator up")

vim.api.nvim_set_current_win(bottom)
height = vim.api.nvim_win_get_height(bottom)
splits.resize("down")
assert(vim.api.nvim_win_get_height(bottom) == height - 3, "resize down should move the separator down")
splits.resize("up")
assert(vim.api.nvim_win_get_height(bottom) == height, "resize up should move the separator up")
