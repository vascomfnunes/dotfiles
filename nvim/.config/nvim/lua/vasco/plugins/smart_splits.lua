return {
  'mrjones2014/smart-splits.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    { '<C-h>', '<cmd>SmartCursorMoveLeft<cr>', desc = 'Move left' },
    { '<C-j>', '<cmd>SmartCursorMoveDown<cr>', desc = 'Move down' },
    { '<C-k>', '<cmd>SmartCursorMoveUp<cr>', desc = 'Move up' },
    { '<C-l>', '<cmd>SmartCursorMoveRight<cr>', desc = 'Move right' },
    { '˙', '<cmd>SmartResizeLeft<cr>', desc = 'Resize left' },
    { '∆', '<cmd>SmartResizeDown<cr>', desc = 'Resize down' },
    { '˚', '<cmd>SmartResizeUp<cr>', desc = 'Resize up' },
    { '¬', '<cmd>SmartResizeRight<cr>', desc = 'Resize right' },
  },
  opts = {},
}
