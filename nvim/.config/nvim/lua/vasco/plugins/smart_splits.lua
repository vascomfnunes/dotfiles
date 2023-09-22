return {
  'mrjones2014/smart-splits.nvim',
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    vim.keymap.set('n', '<C-h>', '<cmd>SmartCursorMoveLeft<cr>', { desc = 'Move left' }),
    vim.keymap.set('n', '<C-j>', '<cmd>SmartCursorMoveDown<cr>', { desc = 'Move down' }),
    vim.keymap.set('n', '<C-k>', '<cmd>SmartCursorMoveUp<cr>', { desc = 'Move up' }),
    vim.keymap.set('n', '<C-l>', '<cmd>SmartCursorMoveRight<cr>', { desc = 'Move right' }),
    vim.keymap.set('n', '<A-h>', '<cmd>SmartResizeLeft<cr>', { desc = 'Resize left' }),
    vim.keymap.set('n', '<A-j>', '<cmd>SmartResizeDown<cr>', { desc = 'Resize down' }),
    vim.keymap.set('n', '<A-k>', '<cmd>SmartResizeUp<cr>', { desc = 'Resize up' }),
    vim.keymap.set('n', '<A-l>', '<cmd>SmartResizeRight<cr>', { desc = 'Resize right' }),
  },
  config = function()
    require('smart-splits').setup {
      -- add any options here
    }
  end,
}
