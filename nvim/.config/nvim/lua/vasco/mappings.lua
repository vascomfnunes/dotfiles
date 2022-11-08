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

keymap('n', '<leader>e', ':NvimTreeToggle<CR>')

keymap('n', '<leader>ff', require('telescope.builtin').find_files)
keymap('n', '<leader>fh', require('telescope.builtin').help_tags)
keymap('n', '<leader>fG', require('telescope.builtin').grep_string)
keymap('n', '<leader>fg', require('telescope.builtin').live_grep)
keymap('n', '<leader>s', require('spectre').open)
