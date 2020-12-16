set tabstop=4
set shiftwidth=4

nmap <leader>cf :w<bar>:Dispatch! eslint % --fix<cr>
nmap <leader>cl :Dispatch eslint %<cr>
