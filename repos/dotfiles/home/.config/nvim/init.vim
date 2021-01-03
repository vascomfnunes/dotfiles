lua require 'init'

fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

" Tests
let test#strategy = "floaterm"
let test#ruby#rspec#executable = 'RUBYOPT="-W0" bundle exec rspec'
let g:test#javascript#runner = 'jest'
let test#ruby#rspec#options = {
      \ 'all': '--require $HOME/bin/rspec_quick_fix_formatter.rb --format QuickfixFormatter --out $HOME/quickfix.out --format progress --color'
      \}

nnoremap <leader>tl :cg $HOME/quickfix.out \| cwindow<cr>

" LSP
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
