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
