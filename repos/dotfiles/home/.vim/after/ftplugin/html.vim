set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()
nnoremap <leader>cl :Dispatch html-linter %<cr>
nnoremap <leader>cf :Dispatch! prettier % -w<cr>
