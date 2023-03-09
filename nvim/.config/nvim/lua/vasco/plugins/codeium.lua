return {
  'Exafunction/codeium.vim',
  event = 'VeryLazy',
  config = function()
    vim.g.codeium_enabled = false
    vim.keymap.set('i', '<C-g>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true })
  end,
}
