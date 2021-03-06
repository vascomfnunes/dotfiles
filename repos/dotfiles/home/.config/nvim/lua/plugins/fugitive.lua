vim.cmd [[packadd vim-fugitive]]

vim.api.nvim_set_keymap('n', '<leader>gs', ':Gstatus<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gc', ':Gcommit<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gb', ':Gblame<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gp', ':Gpull<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gl', ':Glog<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gf', ':Gfetch<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gP', ':Gpush<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gd', ':Gdiffsplit!<CR>', {noremap = true, silent = true})
