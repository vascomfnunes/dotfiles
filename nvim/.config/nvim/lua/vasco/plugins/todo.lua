return {
  'folke/todo-comments.nvim',
  cmd = { 'TodoTrouble', 'TodoTelescope' },
  event = 'VeryLazy',
  opts = {},
  keys = {
    {
      ']t',
      function()
        require('todo-comments').jump_next()
      end,
      desc = 'Next Todo Comment',
    },
    {
      '[t',
      function()
        require('todo-comments').jump_prev()
      end,
      desc = 'Previous Todo Comment',
    },
    { '<leader>st', '<cmd>TodoFzfLua<cr>', desc = 'Todo' },
    { '<leader>sT', '<cmd>TodoFzfLua keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme' },
  },
}
