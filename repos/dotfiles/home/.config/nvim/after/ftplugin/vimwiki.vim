setlocal autoindent formatoptions=tcroqn2 comments=n:>
setlocal conceallevel=2
syn spell toplevel
syn case ignore
syn sync linebreaks=1
setlocal spell
setlocal complete+=kspell
setlocal textwidth=80

" Markdown TOC
nnoremap <silent><Leader>mt :GenTocGitLab<CR>

" Mindmaps from markdown - https://github.com/gera2ld/markmap-lib
nnoremap <silent><leader>mm :!markmap %<CR>

nmap <leader>cl :Dispatch markdownlint %<cr>
nmap <leader>cg :Dispatch languagetool -l en-GB %<cr>
