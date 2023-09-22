return {
  'danymat/neogen',
  cmd = 'Neogen',
  keys = {
    vim.keymap.set('n', '<leader>cg', vim.cmd.Neogen, { desc = 'Generate signature documentation' }),
  },
  opts = { snippet_engine = 'luasnip' },
}
