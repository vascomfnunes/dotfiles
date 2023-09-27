local set = vim.keymap.set
local silent = { silent = true }

-- Disable the Q command
set('n', 'Q', '')

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

-- Spell
set('n', '<leader><space>', function()
  vim.o.spell = not vim.o.spell
end, { desc = 'Toggle spell' })

-- Wrapping
set('n', '<leader>w', '<cmd>set wrap<cr>', { desc = 'Set wrap' })
set('n', '<leader>w', '<cmd>set nowrap<cr>', { desc = 'Unset wrap' })

-- Buffers
set('n', '<Tab>', vim.cmd.bnext, { desc = 'Next buffer' })
set('n', '<S-Tab>', vim.cmd.bprevious, { desc = 'Previous buffer' })
set('n', '.', vim.cmd.bnext, { desc = 'Next buffer' })
set('n', ',', vim.cmd.bprevious, { desc = 'Previous buffer' })
set('n', '<leader>bd', vim.cmd.bwipeout, { desc = 'Remove current buffer' })

-- Tabs
set('n', '<leader><Tab>n', vim.cmd.tabnew, { desc = 'New' })
set('n', '<leader><Tab>c', vim.cmd.tabclose, { desc = 'Close' })
set('n', '<leader><Tab>]', vim.cmd.tabnext, { desc = 'Next' })
set('n', '<leader><Tab>[', vim.cmd.tabprevious, { desc = 'Previous' })

-- Quickfix
set('n', '<leader>qq', function()
  require('vasco.helpers.functions').toggle_qf()
end, { desc = 'Toggle quicklist' })
set('n', '<leader>qj', vim.cmd.cnext, { desc = 'Next' })
set('n', '<leader>qk', vim.cmd.cprevious, { desc = 'Previous' })

-- Lazy
set('n', '<leader>up', vim.cmd.Lazy, { desc = 'Plugins' })

-- Theme
set('n', '<leader>Td', '<cmd>set background=dark<cr>', { desc = 'Dark' })
set('n', '<leader>Tl', '<cmd>set background=light<cr>', { desc = 'Light' })

set('n', '<leader>v', '<cmd>cd ~/.config/nvim|e init.lua<cr>', { desc = 'Neovim configuration' })
