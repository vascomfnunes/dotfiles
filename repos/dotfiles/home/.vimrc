" /*********************************************
" * Description - VIM configuration
" * Author - Vasco Nunes <contact@vasco.dev>
" * Creation Date - Dec 13 2020
" ********************************************/

" Bootstrap vim-plug automatically

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | Plug 'junegunn/fzf.vim'
Plug 'prabirshrestha/vim-lsp' | Plug 'prabirshrestha/async.vim' | Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim' | Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
Plug 'thomasfaingnaert/vim-lsp-snippets' | Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'justinmk/vim-gtfo' " use with got in normal mode to open terminal in current dir
Plug 'DataWraith/auto_mkdir'
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install()  }  }
Plug 'voldikss/vim-floaterm', { 'on': 'FloatermNew' }
Plug 'cohama/lexima.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'editorconfig/editorconfig-vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'AndrewRadev/splitjoin.vim' " adds gS and gJ to syntactically aware split/join constructs
Plug 'romainl/vim-cool'
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch', { 'on': [ 'Dispatch', 'Dispatch!' ] }
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-ragtag', { 'for': 'eruby' }
Plug 'airblade/vim-gitgutter'
Plug 'vim-test/vim-test', { 'on': [ 'TestNearest', 'TestFile', 'TestSuite' ] }
Plug 'vimwiki/vimwiki'
Plug 'sunaku/vim-dasht', { 'on': 'Dasht' }
Plug 'mattn/webapi-vim', { 'on': 'Dasht' }
Plug 'alexbel/vim-rubygems', { 'for': 'ruby' }
Plug 'AndrewRadev/tagalong.vim', { 'for': 'html' }
Plug 'machakann/vim-highlightedyank'
Plug 'ap/vim-css-color', { 'for': ['css', 'scss', 'html'] }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
Plug 'mzlogin/vim-markdown-toc', { 'for': 'markdown' }
Plug 'maxmellon/vim-jsx-pretty', { 'for': 'javascriptreact' }
Plug 'sheerun/html5.vim', { 'for': [ 'html', 'eruby' ]}
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'keith/rspec.vim', { 'for': 'ruby' }
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'posva/vim-vue', { 'for': 'vue' }
Plug 'noprompt/vim-yardoc', { 'for': 'ruby' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'stephpy/vim-yaml', { 'for': 'yaml' }
Plug 'chriskempson/base16-vim'
Plug 'tweekmonster/startuptime.vim'

if exists('$TMUX')
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'RyanMillerC/better-vim-tmux-resizer'
  Plug 'tmux-plugins/vim-tmux-focus-events'
endif
call plug#end()

let g:mapleader=" "

let g:python3_host_prog = "/usr/local/bin/python3"
let g:python_host_prog = "/usr/local/bin/python"

" Automatically install missing plugins on startup
autocmd VimEnter *
      \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \|   PlugInstall --sync | q
      \| endif

set number
set relativenumber
set ttyfast
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
set signcolumn=yes
set nowildignorecase
set wildignore+=.git,.hg,.svn,*.pyc,*.spl,*.o,*.out,*~,%*
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**
set hlsearch incsearch
set splitbelow
set splitright
set expandtab
set spell
set spell spelllang=en_gb
set smartindent
set formatoptions-=o
set mouse=a
set nowrap
set undodir=~/.vim/undo
set undofile
set undolevels=100
set ignorecase
set synmaxcol=500
set diffopt+=iwhite
set lazyredraw
set smartcase
set foldlevelstart=99
set cmdheight=2
set completeopt=menu,menuone,noselect,noinsert,preview
set omnifunc=lsp#complete
set dictionary=/usr/share/dict/words
set thesaurus=~/.vim/thesaurii.txt

let loaded_matchparen = 1

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" STATUSLINE {{{
set statusline=
set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ RPLACE\ ':''}
set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=%#Visual# " colour
set statusline+=%{&paste?'\ PASTE\ ':''}
set statusline+=%{&spell?'\ SPELL\ ':''}
set statusline+=%#CursorIM# " colour
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
set statusline+=%R " readonly flag
set statusline+=%M " modified [+] flag
set statusline+=%#Cursor# " colour
set statusline+=%#CursorLine# " colour
set statusline+=\ %t\ " short file name
set statusline+=%= " right align
set statusline+=%#CursorLine# " colour
set statusline+=\ %Y\ " file type
set statusline+=%#CursorIM# " colour
set statusline+=\ %3l:%-2c\ " line + column
set statusline+=%#Cursor# " colour
set statusline+=\ %3p%%\ " percentage
set foldmethod=manual
" }}}

" AUTOCOMMANDS {{{
" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif
" }}}

" FUNCTIONS {{{
function FileHeading()
  let s:line=line(".")
  call setline(s:line,"/*********************************************")
  call append(s:line,"* Description - ")
  call append(s:line+1,"* Author - Vasco Nunes <contact@vasco.dev>")
  call append(s:line+2,"* Creation Date - ".strftime("%b %d %Y"))
  call append(s:line+4,"********************************************/")
  unlet s:line
endfunction

nmap <leader>h <Esc>mz:execute FileHeading()<cr>

" Delete all whitespaces on save

fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

autocmd BufWritePre * :call TrimWhitespace()
" }}}

" MAPPINGS {{{
" Open quickfix
nnoremap <leader>q :copen<cr>
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
nnoremap <leader>ss :mks ~/.vim/sessions/
nnoremap <leader>sl :source ~/.vim/sessions/
" Jump to tag for css and scss classes
nnoremap <leader>] :tag /<c-r>=expand('<cword>')<cr><cr>
" Easy motion
nmap f <Plug>(easymotion-s2)
" }}}

" PLUGINS {{{
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

" Fzf
let g:fzf_buffers_jump = 1

nnoremap <leader>ff :GFiles<cr>
nnoremap <leader>fF :Files<cr>
nnoremap <leader>fo :BTags<cr>
nnoremap <leader>fb :Buffers<cr>
nnoremap <leader>fs :Snippets<cr>
nnoremap <leader>fh :Helptags<cr>
nnoremap <leader>ft :Tags<cr>
nnoremap <leader>fg :Rg<cr>
nnoremap <silent> <Leader>fG :Rg <C-R><C-W><CR>

" UltiSnippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Highlight Yank
let g:highlightedyank_highlight_duration = 300
highlight HighlightedyankRegion ctermbg=red ctermfg=black

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

" Fugitive
autocmd BufReadPost fugitive://* set bufhidden=delete

" Markdown preview
let vim_markdown_preview_github=1
let vim_markdown_preview_toggle=1
let vim_markdown_preview_browser='Google Chrome'

" Remove the rendered preview
let vim_markdown_preview_temp_file=1

nnoremap <leader>mp :MarkdownPreview<CR>

" Floaterm
nnoremap e :FloatermNew vifm<CR>

nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gp :Gpull<cr>
nnoremap <leader>gl :Glog<cr>
nnoremap <leader>gf :Gfetch<cr>
nnoremap <leader>gP :Gpush<cr>
nnoremap <leader>gd :Gdiffsplit!<cr>

" Dasht
nnoremap <Leader>k :Dasht<Space>
nnoremap <silent> <Leader>K :call Dasht(dasht#cursor_search_terms())<Return>
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

" Guttentags
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['package.json', '.git']
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \
      \ ]

let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]

" Lsp
let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_highlights_enabled = 0
let g:lsp_textprop_enabled = 0
let g:lsp_signs_error = {'text': 'x'}
let g:lsp_signs_warning = {'text': '!'}
let g:lsp_signs_hint = {'text': 'i'}

function! s:on_lsp_buffer_enabled() abort
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> gk <plug>(lsp-hover)

  let g:asyncomplete_auto_completeopt = 0
  let g:asyncomplete_auto_popup = 1
  set completeopt=menuone,noinsert,noselect,preview
  inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
  call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'allowlist': ['*'],
        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
        \
        \ }))
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Goyo
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  hi LineNr ctermbg=none ctermfg=11
  hi SignColumn ctermbg=none
  hi SpellBad ctermbg=NONE ctermfg=3
  hi SpellLocal ctermbg=NONE ctermfg=3
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nnoremap <leader>z :Goyo<cr>

" Lexima
let g:lexima_enable_endwise_rules = 1

" Doge
let g:doge_enable_mappings = 0
nnoremap <leader>cd :DogeGenerate<CR>

" Gitgutter
let g:gitgutter_set_sign_backgrounds = 1
" }}}

" THEME {{{
set background=dark
colorscheme base16-gruvbox-dark-pale

" Change cursor between normal/insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

hi LineNr ctermbg=none ctermfg=11
hi SignColumn ctermbg=none
hi SpellBad ctermbg=NONE ctermfg=3
hi SpellLocal ctermbg=NONE ctermfg=3
hi LspWarningVirtual ctermfg=3
hi LspErrorVirtual ctermfg=1
hi LspInformationVirtual ctermfg=2
hi LspInformationText ctermbg=NONE ctermfg=4
hi SpellBad ctermbg=NONE ctermfg=3 cterm=undercurl
hi SpellLocal ctermbg=NONE ctermfg=3 cterm=undercurl
"}}}
