set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()

nmap <leader>cf :w<bar>:Dispatch! prettier % -w<cr>
nmap <leader>cl :Dispatch eslint %<cr>
