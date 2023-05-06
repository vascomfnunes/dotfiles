local set_keymap = vim.keymap.set
local silent = { silent = true }

-- Disable the Q command
set_keymap('n', 'Q', '')

-- Indentation
set_keymap('v', '<', '<gv', silent) -- indent left
set_keymap('v', '>', '>gv', silent) -- indent right

-- Yank
set_keymap('n', 'x', '"_x', silent)
set_keymap('n', 'X', '"_X', silent)
set_keymap('v', 'x', '"_x', silent)
set_keymap('v', 'X', '"_X', silent)
set_keymap('n', 'r', '"_r', silent)
set_keymap('n', 'c', '"_c', silent)

-- Don't yank on visual paste
set_keymap('v', 'p', '"_dP', silent)

-- Faster vertical navigation
set_keymap('n', '<c-d>', '<c-d>zz')
set_keymap('n', '<c-u>', '<c-u>zz')

-- Clear highlight on escape in normal mode (use <esc> instead of ^[)
set_keymap('n', '<esc>', ':noh<cr>')
