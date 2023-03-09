return {
  'folke/todo-comments.nvim',
  requires = 'nvim-lua/plenary.nvim',
  event = 'VeryLazy',
  config = function()
    require('todo-comments').setup {}
  end,
}
