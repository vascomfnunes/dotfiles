return {
  'danymat/neogen',
  cmd = 'Neogen',
  keys = {
    { '<leader>cg', vim.cmd.Neogen, desc = 'Generate signature documentation' },
  },
  opts = { snippet_engine = 'luasnip' },
}
