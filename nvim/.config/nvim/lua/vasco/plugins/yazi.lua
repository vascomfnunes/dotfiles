return {
  'mikavilpas/yazi.nvim',
  cmd = 'Yazi',
  keys = {
    {
      '<leader>e',
      '<cmd>Yazi<cr>',
      desc = 'Open yazi at the current file',
    },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = '?',
    },
  },
}
