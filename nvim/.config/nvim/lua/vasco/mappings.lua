local set = vim.keymap.set
local silent = { silent = true }

-- Disable the Q command
set('n', 'Q', '')

-- Indentation
set('v', '<', '<gv', { desc = 'Indent left' })
set('v', '>', '>gv', { desc = 'Indent right' })

-- Splits
set('n', 'vv', '<C-w>v', { desc = 'Split vertical' })
set('n', 'ss', '<C-w>s', { desc = 'Split horizontal' })
set('n', 'Zz', '<C-w>|<C-w>_', { desc = 'Split zoom in' })
set('n', 'Zo', '<C-w>=', { desc = 'Split zoom out' })

-- Yank
set('n', 'x', '"_x', silent)
set('n', 'X', '"_X', silent)
set('v', 'x', '"_x', silent)
set('v', 'X', '"_X', silent)
set('n', 'r', '"_r', silent)
set('n', 'c', '"_c', silent)

-- Don't yank on visual paste
set('v', 'p', '"_dP', silent)

-- Move Lines
set('n', '<A-C-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
set('n', '<A-C-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
set('i', '<A-C-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
set('i', '<A-C-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
set('v', '<A-C-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
set('v', '<A-C-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Faster vertical navigation
set('n', '<c-d>', '<c-d>zz')
set('n', '<c-u>', '<c-u>zz')

-- Clear highlight on escape in normal mode (use <esc> instead of ^[)
set('n', '<esc>', ':noh<cr>', { desc = 'Clear highlights' })
