local keymap = vim.keymap.set
local silent = { silent = true }

keymap('n', 'Q', '<nop>')

-- Indentation
keymap('v', '<', '<gv') -- indent left
keymap('v', '>', '>gv') -- indent right

-- Yank
-- send some operations to _ registry
keymap('n', 'x', '"_x', silent)
keymap('n', 'X', '"_X', silent)
keymap('v', 'x', '"_x', silent)
keymap('v', 'X', '"_X', silent)
keymap('n', 'r', '"_r', silent)
keymap('n', 'c', '"_c', silent)

-- Don't yank on visual paste
keymap('v', 'p', '"_dP', silent)

-- Faster vertical navigation
keymap('n', '<c-d>', '<c-d>zz')
keymap('n', '<c-u>', '<c-u>zz')

-- Wezterm integration
vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
-- moving between splits
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
-- swapping buffers between windows
vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)
