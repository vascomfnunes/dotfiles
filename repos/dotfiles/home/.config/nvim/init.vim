lua require 'plugins'
lua require 'settings'
lua require 'mappings'
lua require 'lsp.init'
" lua require 'plugins.express_line'
lua require 'plugins.treesitter'
lua require 'plugins.vifm'
" lua require 'plugins.nvimtree'.setup()
lua require 'plugins.ultisnips'
lua require 'plugins.gitgutter'
lua require 'plugins.fugitive'
lua require 'plugins.telescope'
lua require 'theme'

" AUTOCOMMANDS {{{
" Source the init.vim file after saving it
if has("autocmd")
  autocmd bufwritepost init.vim source $MYVIMRC
endif

au FileType html,css,scss EmmetInstall

au TextYankPost * silent! lua vim.highlight.on_yank()
" }}}

" Delete all whitespaces on save

fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

autocmd BufWritePre * :call TrimWhitespace()
" }}}

" MAPPINGS {{{
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

" Tests
let test#strategy = "neovim"
let test#ruby#rspec#executable = 'RUBYOPT="-W0" bundle exec rspec'
let g:test#javascript#runner = 'jest'
let test#ruby#rspec#options = {
      \ 'all': '--require $HOME/bin/rspec_quick_fix_formatter.rb --format QuickfixFormatter --out $HOME/quickfix.out --format progress --color'
      \}

nnoremap <leader>tn :TestNearest<cr>
nnoremap <leader>tf :TestFile<cr>
nnoremap <leader>ts :TestSuite<cr>
nnoremap <leader>tl :cg $HOME/quickfix.out \| cwindow<cr>

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
let g:vimwiki_folding ='expr'

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
let vim_markdown_preview_github = 1
let vim_markdown_preview_toggle = 1
let vim_markdown_preview_browser = 'Google Chrome'

" Remove the rendered preview
let vim_markdown_preview_temp_file = 1

nnoremap <leader>mp :MarkdownPreview<CR>

" Fugitive
autocmd BufReadPost fugitive://* set bufhidden=delete

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
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nnoremap <leader>z :Goyo<cr>

" LSP
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" }}}

lua require('colorizer').setup()
