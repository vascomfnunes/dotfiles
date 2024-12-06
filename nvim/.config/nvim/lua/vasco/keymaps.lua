local set = vim.keymap.set
local opts = { expr = true, silent = true }
local silent = { silent = true }
local toggle = require 'vasco.utils.toggle'

-- Disable the Q command
set('n', 'Q', '')

-- Better up/down
set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", opts)
set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", opts)
set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", opts)
set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", opts)

-- Indentation
set('v', '<', '<gv', { desc = 'Indent left' })
set('v', '>', '>gv', { desc = 'Indent right' })

-- Splits
set('n', 'vv', '<C-w>v', { desc = 'Split vertical' })
set('n', 'ss', '<C-w>s', { desc = 'Split horizontal' })
set('n', 'Zz', '<C-w>|<C-w>_', { desc = 'Split zoom in' })
set('n', 'Zo', '<C-w>=', { desc = 'Split zoom out' })

-- Yank
set('n', 'x', '"_x', silent)
set('n', 'X', '"_X', silent)
set('v', 'x', '"_x', silent)
set('v', 'X', '"_X', silent)
set('n', 'r', '"_r', silent)
set('n', 'c', '"_c', silent)

-- Don't yank on visual paste
set('v', 'p', '"_dP', silent)

-- Faster vertical navigation
set('n', '<c-d>', '<c-d>zz')
set('n', '<c-u>', '<c-u>zz')

-- Clear highlight on escape in normal mode (use <esc> instead of ^[)
set('n', '<esc>', ':noh<cr>', { desc = 'Clear highlights' })

-- Buffers
set('n', '.', vim.cmd.bnext, { desc = 'Next buffer' })
set('n', ',', vim.cmd.bprevious, { desc = 'Previous buffer' })
set('n', '<leader>bd', vim.cmd.bwipeout, { desc = 'Remove current buffer' })

-- Tabs
set('n', '<leader><Tab>n', vim.cmd.tabnew, { desc = 'New' })
set('n', '<leader><Tab>c', vim.cmd.tabclose, { desc = 'Close' })
set('n', '<Tab>', vim.cmd.tabnext, { desc = 'Next' })
set('n', '<S-Tab>', vim.cmd.tabprevious, { desc = 'Previous' })

-- Quickfix
set('n', '<leader>qq', function()
  require('vasco.utils.quickfix').toggle_qf()
end, { desc = 'Toggle quicklist' })

set('n', '<leader>qj', vim.cmd.cnext, { desc = 'Next' })
set('n', '<leader>qk', vim.cmd.cprevious, { desc = 'Previous' })

-- Lazy
set('n', '<leader>vl', vim.cmd.Lazy, { desc = 'Lazy' })

-- Utils
set('n', '<leader>us', function()
  toggle 'spell'
end, { desc = 'Toggle Spelling' })
set('n', '<leader>uw', function()
  toggle 'wrap'
end, { desc = 'Toggle Word Wrap' })
set('n', '<leader>uL', function()
  toggle 'relativenumber'
end, { desc = 'Toggle Relative Line Numbers' })
set('n', '<leader>ul', function()
  toggle.number()
end, { desc = 'Toggle Line Numbers' })
set('n', '<leader>ud', function()
  toggle.diagnostics()
end, { desc = 'Toggle Diagnostics' })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
set('n', '<leader>uc', function()
  toggle('conceallevel', false, { 0, conceallevel })
end, { desc = 'Toggle Conceal' })
if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
  set('n', '<leader>uh', function()
    toggle.inlay_hints()
  end, { desc = 'Toggle Inlay Hints' })
end
set('n', '<leader>uT', function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
  else
    vim.treesitter.start()
  end
end, { desc = 'Toggle Treesitter Highlight' })

-- Theme
set('n', '<leader>Cd', '<cmd>colorscheme base16-gruvbox-material-dark-medium<cr>', { desc = 'Dark' })
set('n', '<leader>Cl', '<cmd>colorscheme base16-gruvbox-material-light-medium<cr>', { desc = 'Light' })
