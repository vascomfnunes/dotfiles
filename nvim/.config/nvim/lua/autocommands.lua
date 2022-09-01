-- AUTOCOMMANDS
--

local custom_group = vim.api.nvim_create_augroup('CustomCmdGroup', { clear = true })

-- Highlight line on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = custom_group,
  pattern = '*',
})

-- Trim whitespaces
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = custom_group,
  pattern = { '*' },
  command = '%s/\\s\\+$//e',
})

-- Disable diagnostics for specific patterns
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = custom_group,
  pattern = { '*/node_modules/*' },
  command = 'lua vim.diagnostic.disable(0)',
})

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = custom_group,
  pattern = { '*.txt', '*.md' },
  command = 'setlocal spell',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'lua',
    'html',
    'ruby',
    'eruby',
    'javascript',
    'typescript',
    'markdown',
    'javascriptreact',
    'typescriptreact',
    'bash',
    'scss',
    'css',
    'python',
    'csharp',
    'yaml',
  }, -- enable spellchecking for these filetypes
  command = 'setlocal spell',
  group = custom_group,
})
