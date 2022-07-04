-- Load abreviations
vim.cmd [[iab <expr> :today: strftime("%d-%m-%Y")]]

vim.g.markdown_fenced_languages = {
  'html',
  'python',
  'lua',
  'vim',
  'typescript',
  'javascript',
  'ruby',
  'css',
  'scss',
  'bash',
}

vim.opt_local.linebreak = true
vim.opt_local.autoindent = true
vim.opt_local.indentexpr = ''
vim.opt_local.wrap = true
vim.opt_local.tw = 80
vim.opt_local.formatoptions = 'tqlnwa'
vim.opt_local.complete:append 'k'
