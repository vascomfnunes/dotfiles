setlocal foldmethod=marker

" Lsp server settings
setlocal omnifunc=lsp#complete
if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

" see h:fo-table for options
setlocal formatoptions=tcqj

normal zM
