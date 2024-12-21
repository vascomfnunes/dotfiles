return {
  'kristijanhusak/vim-dadbod-ui',
  event = 'VimEnter',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
  keys = {
    {
      '<leader>dd',
      '<cmd>DBUIToggle<CR>',
      desc = 'Databases',
    },
  },
}
