setlocal autoindent formatoptions=tcroqn2 comments=n:>
setlocal conceallevel=2
syn spell toplevel
syn case ignore
syn sync linebreaks=1
setlocal complete+=kspell
setlocal textwidth=80

" Configuration for vim-markdown
let g:vim_markdown_conceal = 2
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_math = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_autowrite = 1
let g:vim_markdown_edit_url_in = 'tab'
let g:vim_markdown_follow_anchor = 1

" Markdown TOC
nnoremap <silent><Leader>mt :GenTocGitLab<CR>

" Mindmaps from markdown - https://github.com/gera2ld/markmap-lib
nnoremap <silent><leader>mm :!markmap %<CR>

nmap <leader>cl :Dispatch markdownlint %<cr>
nmap <leader>cf :w<bar>:Dispatch! markdownlint % -f<cr>
nmap <leader>cg :Dispatch languagetool -l en-GB %<cr>
