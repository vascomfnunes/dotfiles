setlocal formatoptions=tcqj

" Lsp server settings
setlocal omnifunc=lsp#complete
set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()

if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

nnoremap <leader>cf :Dispatch! prettier % -w<cr>
nnoremap <leader>cl :Dispatch eslint %<cr>
