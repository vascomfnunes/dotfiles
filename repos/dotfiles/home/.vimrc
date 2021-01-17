" File: .vimrc
" Author: Vasco Nunes <contact@vasco.dev>
" Description: Vim 8.x configuration file
" Last Modified: January 10, 2021

" Plugins {{{
" Download and install Plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup plug
    autocmd!
    autocmd VimEnter * PlugInstall | source $MYVIMRC
  augroup END
endif

call plug#begin('~/.vim/plugged')

if exists('$TMUX')
  " Only use these if Tmux is running
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'RyanMillerC/better-vim-tmux-resizer'
  Plug 'tmux-plugins/vim-tmux-focus-events'
endif

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'puremourning/vimspector'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'justinmk/vim-gtfo' " use with got in normal mode to open terminal in current dir
Plug 'DataWraith/auto_mkdir'
Plug 'rhysd/committia.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'cohama/lexima.vim'
Plug 'mattn/emmet-vim', { 'for': ['html', 'eruby', 'css', 'scss'] }
Plug 'dbeniamine/cheat.sh-vim', { 'on': 'Cheat' }
Plug 'editorconfig/editorconfig-vim'
Plug 'easymotion/vim-easymotion'
Plug 'AndrewRadev/splitjoin.vim' " adds gS and gJ to syntactically aware split/join constructs
Plug 'romainl/vim-cool'
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-surround'
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install()  }  }
Plug 'tpope/vim-dispatch', { 'on': [ 'Dispatch', 'Dispatch!' ] }
Plug 'tpope/vim-ragtag', { 'for': 'eruby' }
Plug 'vim-test/vim-test', { 'on': [ 'TestNearest', 'TestFile', 'TestSuite' ] }
Plug 'vimwiki/vimwiki'
Plug 'sunaku/vim-dasht', { 'on': 'Dasht' }
Plug 'mattn/webapi-vim', { 'for': 'Ruby' }
Plug 'alexbel/vim-rubygems', { 'for': 'ruby' }
Plug 'honza/vim-snippets'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vimwiki', 'vim-plug']}
Plug 'dhruvasagar/vim-table-mode', { 'for': ['markdown', 'vimwiki'] }
Plug 'junegunn/vim-peekaboo'
Plug 'sheerun/html5.vim', { 'for': ['html', 'eruby'] }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'martinda/Jenkinsfile-vim-syntax', { 'for': 'jenkins' }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'MaxMEllon/vim-jsx-pretty', { 'for': 'javascriptreact' }
Plug 'plasticboy/vim-markdown', { 'for': ['markdown', 'vimwiki'] }
Plug 'keith/rspec.vim', { 'for': 'rspec.ruby' }
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'arzg/vim-sh', { 'for': 'sh' }
Plug 'ericpruitt/tmux.vim', { 'for': 'tmux' }
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
Plug 'posva/vim-vue', { 'for': 'vue' }
Plug 'noprompt/vim-yardoc', { 'for': 'ruby' }
Plug 'vascomfnunes/vimbox'
Plug 'tweekmonster/startuptime.vim'

call plug#end()
" }}}

" Settings {{{
let g:mapleader=" "

set number
set relativenumber
set showcmd
set clipboard=unnamed
set tabstop=2
set shiftwidth=2
set softtabstop=2
set noswapfile
set hidden
set nojoinspaces
set path+=**
set updatetime=100
set signcolumn=number
set nowildignorecase
set wildignore+=.git,.hg,.svn,*.pyc,*.spl,*.o,*.out,*~,%*
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**
set hlsearch incsearch
set splitbelow
set splitright
set expandtab
set nospell
set spell spelllang=en_gb
set smartindent
set formatoptions-=o
set mouse=a
set nowrap
set undodir=~/.vim/undo
set undofile
set undolevels=100
set synmaxcol=500
set diffopt+=iwhite
set shortmess+=c
set lazyredraw
set smartcase
set foldlevelstart=99
set cmdheight=2
set completeopt=menu,menuone,noselect,noinsert,preview
set dictionary=/usr/share/dict/words
set thesaurus=~/.vim/thesaurii.txt
set termguicolors
" }}}

" Autocommands {{{
" Source the vimrc file after saving it
augroup vim
  autocmd!
  autocmd bufwritepost .vimrc source $MYVIMRC
augroup END

" Delete all whitespaces on save
fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

augroup whitespace
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
augroup END

" Update lightline when Coc status changes
augroup lightline
  autocmd!
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
augroup END
" }}}

" General remaps {{{
" Disable annoying visual mode
nnoremap Q <nop>

" Open terminal
nnoremap <c-t> :terminal<cr>

" Windows splits
nnoremap <silent> vv <c-w>v
nnoremap <silent> ss <c-w>s

" Clear highlights
nnoremap <leader>n :noh<cr>

" Tabs
nnoremap <leader><tab>n :tabnew<cr>
nnoremap <leader><tab>q :tabclose<cr>
nnoremap <tab> :tabnext<cr>
nnoremap <S-tab> :tabprevious<cr>

" Sessions
nnoremap <silent><leader>ss :CocCommand session.save<cr>
nnoremap <silent><leader>sl :CocList sessions<cr>

" Explorer
nnoremap <leader>e :CocCommand explorer<cr>

" Fuzzy finder
nnoremap <leader>ff :CocList files<cr>
nnoremap <leader>fF :CocList gfiles<cr>
nnoremap <leader>fs :CocList symbols<cr>
nnoremap <leader>fo :CocList outline<cr>
nnoremap <leader>fd :CocList diagnostics --current-buf<cr>
nnoremap <leader>fb :CocList buffers<cr>
nnoremap <leader>ft :CocList tags<cr>
nnoremap <leader>fg :CocList grep<space>
nnoremap <leader>fG :CocList grep <C-R><C-W><cr>
" }}}

" Plugin settings {{{
" Easy motion
nmap f <Plug>(easymotion-s2)

" Tests
let test#strategy = "vimterminal"
let test#ruby#rspec#executable = 'RUBYOPT="-W0" bundle exec rspec'
let g:test#javascript#runner = 'jest'
let test#ruby#rspec#options = {
      \ 'all': '--require ~/bin/rspec_quick_fix_formatter.rb --format QuickfixFormatter --out ~/quickfix.out --format progress --color'
      \}

nnoremap <leader>tn :TestNearest<cr>
nnoremap <leader>tf :TestFile<cr>
nnoremap <leader>ts :TestSuite<cr>
nnoremap <leader>tl :cg ~/quickfix.out \| cwindow<cr>

" Vimwiki
let g:markdown_folding = 1

let wiki_1 = {}
let wiki_1.path = '~/vimwiki_work_md/'
let wiki_1.syntax = 'markdown'
let wiki_1.ext = '.md'

let wiki_2 = {}
let wiki_2.path = '~/vimwiki_personal_md/'
let wiki_2.syntax = 'markdown'
let wiki_2.ext = '.md'

let g:vimwiki_list = [wiki_1, wiki_2]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_global_ext = 0
let g:vimwiki_key_mappings =
      \ {
      \   'all_maps': 1,
      \   'global': 1,
      \   'headers': 1,
      \   'text_objs': 1,
      \   'table_format': 1,
      \   'table_mappings': 1,
      \   'lists': 1,
      \   'links': 1,
      \   'html': 1,
      \   'mouse': 1,
      \ }

let g:vimwiki_listsyms = '✗○◐●✓'
let g:vimwiki_folding='expr'

nnoremap <leader>di :VimwikiDiaryIndex<CR>
nnoremap <leader>dn :VimwikiMakeDiaryNote<CR>
nnoremap <leader>dy :VimwikiMakeYesterdayDiaryNote<CR>
nnoremap <leader>dt :VimwikiMakeTomorrowDiaryNote<CR>
nnoremap <leader>dtt :r !~/bin/vimwiki_diary_template %<CR>
nnoremap <leader>dg :VimwikiDiaryGenerateLinks<CR>
nnoremap <leader>wd :VimwikiDeleteFile<CR>
nnoremap <leader>wr :VimwikiRenameFile<CR>
nnoremap <leader>ws :VimwikiUISelect<CR>
nnoremap <leader>wt :VimwikiTable cols rows

" Markdown preview
let vim_markdown_preview_github=1
let vim_markdown_preview_toggle=1
let vim_markdown_preview_browser='Google Chrome'

" Remove the rendered preview
let vim_markdown_preview_temp_file=1

nnoremap <leader>mp :MarkdownPreview<CR>

" Dasht
nnoremap <leader>K :Dasht <C-R><C-W><cr>
let g:dasht_results_window = 'vnew'

let g:dasht_filetype_docsets = {}
let g:dasht_filetype_docsets['html'] = ['CSS', 'Javascript', 'Bootstrap_4', 'Emmet', 'Font_Awesome', 'HTML', 'JavaScript', 'MomentJS', 'jQuery']
let g:dasht_filetype_docsets['eruby'] = ['CSS', 'Javascript', 'Bootstrap_4', 'Emmet', 'Font_Awesome', 'HTML', 'JavaScript', 'MomentJS', 'jQuery', 'Ruby_2', 'Ruby_on_Rails_6']
let g:dasht_filetype_docsets['vim'] = ['Vim']
let g:dasht_filetype_docsets['css'] = ['CSS']
let g:dasht_filetype_docsets['scss'] = ['CSS', 'Sass']
let g:dasht_filetype_docsets['javascript'] = ['JavasScript', 'Mocha', 'MomentJS', 'jQuery', 'jQuery_Mobile', 'jQuery_UI']
let g:dasht_filetype_docsets['ruby'] = ['Ruby_2', 'Ruby_onRails_6', 'Ruby_Installed_Gems']
let g:dasht_filetype_docsets['markdown'] = ['Markdown']
let g:dasht_filetype_docsets['docker'] = ['Docker', 'Man_Pages']
let g:dasht_filetype_docsets['bash'] = ['Bash']

" Editor config
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" Fugitive
augroup fugitive
  autocmd!
  autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gp :Gpull<cr>
nnoremap <leader>gl :Glog<cr>
nnoremap <leader>gf :Gfetch<cr>
nnoremap <leader>gP :Gpush<cr>
nnoremap <leader>gd :Gdiffsplit!<cr>

" Lightline
let g:lightline = {}
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste'  ],
      \             [ 'cocstatus', 'gitbranch', 'readonly', 'filename', 'modified'  ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
	    \   'cocstatus': 'coc#status'
      \ },
      \ }

let g:lightline.colorscheme = 'seoul256'

" Tmux
if exists('$TMUX')
  let g:tmux_navigator_no_mappings = 1
  let g:tmux_resizer_no_mappings = 1

  nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
  nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
  nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
  nnoremap <silent> <s-h> :TmuxResizeLeft<cr>
  nnoremap <silent> <s-j> :TmuxResizeDown<cr>
  nnoremap <silent> <s-k> :TmuxResizeUp<cr>
  nnoremap <silent> <s-l> :TmuxResizeRight<cr>
endif

" Coc {{{
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
augroup coc
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

" Symbol renaming.
nmap <leader>rr <Plug>(coc-rename)

" Formatting code.
nmap <leader>cf :call CocAction('format')<cr>

augroup coc
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ca  <Plug>(coc-codeaction)

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap <C-n> and <C-p> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-n> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-p> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-n> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-p> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-n> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-p> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>cd  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>ce  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>cc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>co  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>cs  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Find and jump to references
nnoremap <silent><nowait> <space>cr  :<C-u>call CocAction('jumpReferences')<CR>

nnoremap <leader>cp :call CocAction('pickColor')<cr>

let g:coc_global_extensions = [
      \ 'coc-solargraph', 'coc-css', 'coc-yaml', 'coc-json',
      \ 'coc-markdownlint', 'coc-explorer', 'coc-lists',
      \ 'coc-html', 'coc-yank', 'coc-vimlsp', 'coc-snippets',
      \ 'coc-eslint', 'coc-prettier', 'coc-emmet', 'coc-git', 'coc-highlight',
      \ 'coc-stylelintplus', 'coc-sh', 'coc-diagnostic'
      \ ]
" }}}

" Goyo
nnoremap <leader>z :Goyo<cr>

" Lexima
let g:lexima_enable_endwise_rules = 1

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Snippets
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Cheat
let g:CheatSheetStayInOrigBuf = 0
nnoremap <leader>cc :Cheat<space>

" Emmet
let g:user_emmet_install_global = 0
augroup emmet
  autocmd!
  autocmd FileType html,css,scss EmmetInstall
augroup END

" Filetypes syntax
let g:javascript_plugin_jsdoc = 1
let g:vim_json_syntax_conceal = 0

" Vimspector
nmap <leader>B <Plug>VimspectorToggleBreakpoint
nmap <leader>R <Plug>VimspectorRestart
nmap <leader>S <Plug>VimspectorStop
nmap <leader>H <Plug>VimspectorStepOver
nmap <leader>I <Plug>VimspectorStepInto
nmap <leader>O <Plug>VimspectorStepOut
nmap <leader>C <Plug>VimspectorRunToCursor

" }}}

" Theme {{{
set background=dark
colorscheme vimbox

" Change cursor between normal/insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

nnoremap <leader>bd :set background=dark<cr>
nnoremap <leader>bl :set background=light<cr>
" }}}
