vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Explorer' })

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Files' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Help' })
vim.keymap.set('n', '<leader>fG', require('telescope.builtin').grep_string, { desc = 'Grep current word' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Live grep' })
