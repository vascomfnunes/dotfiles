return {
  'github/copilot.vim',
  cmd = 'Copilot',
  config = function()
    vim.cmd [[imap <silent><script><expr> <C-\> copilot#Accept("\<CR>")]]
    vim.cmd [[let g:copilot_no_tab_map = v:true]]
  end,
}
