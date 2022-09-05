-- MAPPINGS
--

local keymap = vim.keymap.set
local silent = { silent = true }

keymap('n', 'Q', '<nop>')

-- Yank
-- send some operations to _ registry
keymap('n', 'x', '"_x')
keymap('n', 'r', '"_r')
keymap('n', 'c', '"_c')

-- Move text up and down
keymap('v', '<A-j>', ":m '>+1<CR>gv=gv")
keymap('v', '<A-k>', ":m '<-2<CR>gv=gv")
keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi')

-- Don't yank on delete char
keymap('n', 'x', '"_x', silent)
keymap('n', 'X', '"_X', silent)
keymap('v', 'x', '"_x', silent)
keymap('v', 'X', '"_X', silent)

-- Don't yank on visual paste
keymap('v', 'p', '"_dP', silent)
