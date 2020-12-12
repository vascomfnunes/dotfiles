setlocal filetype=markdown
setlocal syntax=markdown
setlocal autoindent formatoptions=tcroqn2 comments=n:>
setlocal conceallevel=2
syn spell toplevel
syn case ignore
syn sync linebreaks=1
setlocal spell spelllang=en_gb
setlocal complete+=kspell
setlocal textwidth=80

" Markdown preview
let vim_markdown_preview_github=1
let vim_markdown_preview_toggle=1
let vim_markdown_preview_browser='Google Chrome'

" Remove the rendered preview
let vim_markdown_preview_temp_file=1

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

" Markdown preview
nnoremap <silent><leader>mp :MarkdownPreview<CR>

" Mindmaps from markdown - https://github.com/gera2ld/markmap-lib
nnoremap <silent><leader>mm :!markmap %<CR>

nnoremap <leader>cl :Dispatch markdownlint %<cr>
nnoremap <leader>cf :Dispatch! markdownlint % -f<cr>
nnoremap <leader>cg :Dispatch languagetool -l en-GB %<cr>
