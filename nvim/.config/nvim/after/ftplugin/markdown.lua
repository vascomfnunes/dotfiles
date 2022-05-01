vim.cmd [[setlocal spell]]
vim.cmd [[setlocal wrap]]
vim.cmd [[setlocal linebreak]]
vim.cmd [[setlocal autoindent]]
vim.cmd [[setlocal textwidth=80]]
vim.cmd [[setlocal formatoptions=tqlnwa]]
vim.cmd [[setlocal complete+=k]]

-- Load abreviations
vim.cmd [[iab <expr> :today: strftime("%d-%m-%Y")]]

vim.opt_local.linebreak = true
vim.opt_local.autoindent = true
vim.opt_local.indentexpr = ''
vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_gb'
vim.opt_local.tw = 80

vim.cmd [[setlocal complete+=k]]
vim.cmd [[setlocal formatoptions-=c]]
