return {
  'rachartier/tiny-code-action.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
  },
  event = 'LspAttach',
  config = function()
    require('tiny-code-action').setup()
  end,
}
