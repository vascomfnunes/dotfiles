-- Load abreviations
vim.cmd [[iab <expr> :today: strftime("%d-%m-%Y")]]

vim.opt_local.linebreak = true
vim.opt_local.autoindent = true
vim.opt_local.indentexpr = ''
vim.opt_local.wrap = true
vim.opt_local.tw = 80
vim.opt_local.formatoptions = 'tqlnwa'
vim.opt_local.complete:append 'k'
vim.opt_local.conceallevel = 1
vim.opt_local.spell = true
