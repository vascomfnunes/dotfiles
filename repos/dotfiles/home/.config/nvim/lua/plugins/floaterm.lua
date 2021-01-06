vim.cmd [[packadd vim-floaterm]]

vim.api.nvim_set_keymap('n', 'e', ':FloatermNew vifm<CR>', {noremap = true, silent = true})
