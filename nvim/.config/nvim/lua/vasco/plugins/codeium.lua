return {
  'Exafunction/codeium.vim',
  lazy = false,
  config = function()
    vim.cmd [[ let g:codeium_enabled = v:false ]]
    vim.keymap.set('i', '<C-g>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true })
    vim.keymap.set('i', '<C-]>', function()
      return vim.fn['codeium#CycleCompletions'](1)
    end, { expr = true })
    vim.keymap.set('i', '<c-x>', function()
      return vim.fn['codeium#Clear']()
    end, { expr = true })
  end,
}
