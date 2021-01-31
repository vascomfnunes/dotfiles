setlocal spell
setlocal wrap
setlocal linebreak
setlocal textwidth=80

" Markdown TOC
nnoremap <silent><Leader>mt :GenTocGitLab<CR>

" Mindmaps from markdown - https://github.com/gera2ld/markmap-lib
nnoremap <silent><leader>mm :!markmap %<CR>

nmap <leader>cl :Dispatch markdownlint %<cr>
nmap <leader>cg :Dispatch languagetool -l en-GB %<cr>
