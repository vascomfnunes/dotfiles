setlocal formatoptions=tcqj

" Lsp server settings
setlocal omnifunc=lsp#complete
setlocal foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()
if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

let g:ruby_operators = 1
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:ruby_pseudo_operators = 1
let g:ruby_fold = 1
let g:rubycomplete_rails = 1

" RAILS STUFF

let g:rails_ctags_arguments = ['--languages=Ruby', '--exclude=.git', '--exclude=log']

" Autocomplete Rails routes
" Use with <leader>r
function! s:parse_route(selected)
  let l:squished = substitute(join(a:selected), '^\s\+', '', '')
  return split(l:squished)[0] . '_path'
endfunction

inoremap <expr> § fzf#complete({
      \ 'source':  'rails routes',
      \ 'reducer': '<sid>parse_route'})
nnoremap <leader>rm :Emodel<space>
nnoremap <leader>rc :Econtroller<space>
nnoremap <leader>rv :Eview<space>
nnoremap <leader>rt :Espec<space>
nnoremap <leader>rf :Efixtures<space>
nnoremap <leader>rh :Ehelper<space>
nnoremap <leader>rj :Ejavascript<space>
nnoremap <leader>rl :Elayout<space>
nnoremap <leader>rs :Estylesheet<space>
nnoremap <leader>ri :Elocale<space>

" Ruby gems
nmap <leader>rgi :RubygemsGemInfo<CR>
nmap <leader>rgv :RubygemsVersions<CR>
nmap <leader>rgl :RubygemsRecentVersion<CR>
nmap <leader>rga :RubygemsAppendVersion<CR>
nmap <leader>rgs :RubygemsSearch<space>

" Edit alternate files on Rails
nnoremap <leader>a :A<CR>

" Linting and fixing
nnoremap <leader>cl :Dispatch rubocop %<cr>
nnoremap <leader>cf :LspDocumentFormat<cr>

" Insert debug breakpoint
nnoremap <leader>cb obinding.pry<esc>==:w<cr>
