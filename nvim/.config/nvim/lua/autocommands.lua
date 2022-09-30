-- AUTOCOMMANDS
--

local custom_group = vim.api.nvim_create_augroup('CustomCmdGroup', { clear = true })

-- Highlight line on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank { higroup = 'Visual', timeout = 200 }
  end,
  group = custom_group,
  pattern = '*',
})

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  group = custom_group,
  pattern = { 'plugins.lua' },
  command = 'source <afile> | PackerSync',
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

-- Cursorline only on active window
vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
  group = custom_group,
  pattern = { '*' },
  command = 'setlocal cursorline',
})

vim.api.nvim_create_autocmd({ 'WinLeave' }, {
  group = custom_group,
  pattern = { '*' },
  command = 'setlocal nocursorline',
})

-- dont list quickfix buffers
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = custom_group,
  pattern = { 'qf' },
  callback = function()
    vim.opt_local.buflisted = false
  end,
})
