set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()

nnoremap <leader>cf :Dispatch! prettier % -w<cr>
nnoremap <leader>cl :Dispatch eslint %<cr>
