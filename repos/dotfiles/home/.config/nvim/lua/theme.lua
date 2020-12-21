vim.cmd('colorscheme vimbox')

vim.o.termguicolors = true
vim.o.background = 'dark'

vim.api.nvim_set_keymap('n', '<leader>bd', ':set background=dark<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bl', ':set background=light<CR>', { noremap = true, silent = true })
