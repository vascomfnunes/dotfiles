local custom_group = vim.api.nvim_create_augroup('CustomCmdGroup', { clear = true })

-- Highlight line on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank { higroup = 'Visual', timeout = 200 }
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

-- dont list quickfix buffers
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = custom_group,
  pattern = { 'qf' },
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match

    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    local backup = vim.fn.fnamemodify(file, ':p:~:h')
    backup = backup:gsub('[/\\]', '%%')
    vim.go.backupext = backup
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
  pattern = {
    'qf',
    'help',
    'man',
    'notify',
    'lspinfo',
    'spectre_panel',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- linter
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint()
  end,
})
