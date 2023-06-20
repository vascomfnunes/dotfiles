return {
  'ruifm/gitlinker.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'BufReadPost',
  config = function()
    require('gitlinker').setup {}
  end,
}
