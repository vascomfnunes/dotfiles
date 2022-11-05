set nocompatible
syntax on
set encoding=utf8
filetype off

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'

if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Automatically reloading of .vimrc
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

" PLUGINS
" {{{
call plug#begin()
Plug 'chriskempson/base16-vim'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-ragtag', { 'for': ['eruby'] }
Plug 'tpope/vim-rails', { 'for': ['ruby', 'eruby'] }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'travisjeffery/vim-auto-mkdir'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'christoomey/vim-tmux-navigator'
Plug 'RyanMillerC/better-vim-tmux-resizer'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install', 'for': ['markdown'] }
Plug 'https://github.com/ap/vim-css-color', { 'for': ['css', 'scss'] }
Plug 'godlygeek/tabular', { 'for': ['vimwiki', 'markdown'] }
Plug 'preservim/vim-markdown', { 'for': ['vimwiki', 'markdown'] }
Plug 'vimwiki/vimwiki'
call plug#end()
" }}}

" COLORS
" {{{

filetype plugin indent on
if !has('gui_running')
  set t_Co=256
endif

" True colors support (need vim to be compiled with +termguicolors)
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark

let base16colorspace=256
colorscheme base16-tomorrow-night-eighties

hi VimwikiHeader1 guifg=#6699cc
hi VimwikiHeader2 guifg=#99cc99
hi VimwikiHeader3 guifg=#f99157
hi VimwikiHeader4 guifg=#4271ae
hi GitGutterAdd guibg=NONE
hi GitGutterChange guibg=NONE
hi GitGutterDelete guibg=NONE
hi clear SignColumn
hi clear LineNr
"}}}

" SETTINGS
" {{{
let mapleader = " "
let maplocalleader = " "

filetype plugin indent on
set autoread
set backspace=indent,eol,start
set clipboard=unnamed,unnamedplus
set completeopt=menuone,longest
set expandtab
set fileencoding=utf-8
set foldmethod=marker
set formatoptions-=t
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set linebreak
set mouse=a
set nobackup
set noerrorbells visualbell t_vb=
set noshowmode
set noswapfile
set nowrap
set nowritebackup
set number
set path+=**
set pumheight=20
set relativenumber
set scrolloff=5
set shiftwidth=2
set shortmess+=c
set showcmd
set showmatch
set signcolumn=yes
set smartcase
set smartindent
set softtabstop=-2
set spelllang=en_gb
set splitbelow
set splitright
set tabstop=2
set textwidth=120
set timeoutlen=500
set ttyfast
set undodir=~/.vim/undo
set undofile
set undolevels=10000
set updatetime=300
set whichwrap+=<,>,h,l  " Allow backspace and cursor keys to cross line boundaries
set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/venv/*,*/target/*,*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls,*/.fdb*/,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk,*/.git,*/tmp
set wildmenu
set wildoptions=pum

" Change cursor on normal/insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
"}}}

" AUTOCOMMANDS
" {{{
" Strip whitespaces on save
autocmd BufWritePre * :%s/\s\+$//e
" Add LSP `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OrganizeImports :call CocActionAsync('runCommand', 'editor.action.organizeImport')
" }}}

" STATUSLINE
" {{{
let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night_Eighties',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'cocstatus' ]]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'cocstatus': 'coc#status'
      \ },
      \ }
" }}}

" COC
" {{{

let g:coc_global_extensions = ['coc-explorer', 'coc-solargraph', 'coc-json', 'coc-sh', 'coc-css', 'coc-html', 'coc-markdownlint']

inoremap <silent><expr> <c-j>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<c-j>" :
      \ coc#refresh()
inoremap <expr><c-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <c-l> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<c-l>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
" }}}

" SNIPPETS
" {{{
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" }}}

" FZF
" {{{
let $FZF_DEFAULT_COMMAND = 'rg --files --ignore-case --hidden -g "!{.git,node_modules,vendor,coverage}/*"'
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:50%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'ctrl-y': {lines -> setreg('*', join(lines, "\n"))}}

" Customize fzf colors to match your color scheme
let g:fzf_colors =
      \ { 'fg':    ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }
"}}}

" TMUX
" {{{
let g:tmux_resizer_no_mappings = 1
" }}}

" VIMWIKI
" {{{
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
" }}}

" MAPPINGS
" {{{
nnoremap <silent><leader>v :e ~/.vimrc<CR>
nnoremap <silent>vv <c-w>v
nnoremap <silent>ss <c-w>s
nnoremap <silent><leader>ff :Files<CR>
nnoremap <silent><leader>fb :Buffers<CR>
nnoremap <silent><leader>fc :Colors<CR>
nnoremap <silent><leader>fh :Helptags<CR>
nnoremap <silent><leader>fg :Rg<CR>
nnoremap <silent><leader>fG :Rg <C-R><C-W><CR>
nnoremap <silent><leader>e :CocCommand explorer<CR>
nnoremap <silent><leader>= :CocCommand editor.action.formatDocument<CR>
inoremap <silent><expr> <c-@> coc#refresh()
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> F :Fold<CR>
nmap <silent> <leader>i :OrganizeImports<CR>
nnoremap <silent><nowait> <leader>d  :<C-u>CocDiagnostics<cr>
nnoremap <silent><nowait> <leader>c  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <leader>o  :<C-u>CocOutline<cr>
nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent> K :call ShowDocumentation()<CR>
nmap <leader>r <Plug>(coc-rename)
nmap <leader>a <Plug>(coc-codeaction)
nmap <leader>gg :G<CR>
nmap <leader>gb :Git blame<CR>
nmap <leader>gd :Git diff<CR>
nmap <leader>gm :Git mergetool<CR>
nmap <leader>mp :MarkdownPreview<CR>
nnoremap <silent> ˙ :TmuxResizeLeft<CR>
nnoremap <silent> ∆ :TmuxResizeDown<CR>
nnoremap <silent> ˚ :TmuxResizeUp<CR>
nnoremap <silent> ¬ :TmuxResizeRight<CR>

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" easier moving of code blocks
vnoremap < <gv
vnoremap > >gv

" toggle hlsearch
nnoremap <silent> <Leader><space> :set hls!<cr>

" move line up and down
" nnoremap <S-Up>   :<C-u>silent! move-2<CR>==
" nnoremap <S-Down> :<C-u>silent! move+<CR>==
" Alt-j <A-j> mapped to ∆
" Alt-k <A-k> mapped to ˚
nnoremap <M-down> :m .+1<CR>==
nnoremap <M-up> :m .-2<CR>==
vnoremap <M-down> :m '>+1<CR>gv=gv
vnoremap <M-up> :m '<-2<CR>gv=gv

" Prevent x from overriding what's in the clipboard.
noremap x "_x
noremap X "_x

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

nnoremap <silent> <leader>q :call ToggleQuickFix()<cr>
" }}}

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
