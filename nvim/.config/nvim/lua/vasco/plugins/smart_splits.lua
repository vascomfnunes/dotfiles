return {
  'mrjones2014/smart-splits.nvim',
  lazy = false,
  keys = {
    { '<C-h>', '<cmd>SmartCursorMoveLeft<cr>', desc = 'Move left' },
    { '<C-j>', '<cmd>SmartCursorMoveDown<cr>', desc = 'Move down' },
    { '<C-k>', '<cmd>SmartCursorMoveUp<cr>', desc = 'Move up' },
    { '<C-l>', '<cmd>SmartCursorMoveRight<cr>', desc = 'Move right' },
    { '<A-h>', '<cmd>SmartResizeLeft<cr>', desc = 'Resize left' },
    { '<A-j>', '<cmd>SmartResizeDown<cr>', desc = 'Resize down' },
    { '<A-k>', '<cmd>SmartResizeUp<cr>', desc = 'Resize up' },
    { '<A-l>', '<cmd>SmartResizeRight<cr>', desc = 'Resize right' },
  },
  opts = {},
}
