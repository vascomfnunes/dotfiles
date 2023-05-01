return {
  'RyanMillerC/better-vim-tmux-resizer',
  event = 'VimEnter',
  config = function()
    vim.g.tmux_resizer_no_mappings = 1
  end,
}
