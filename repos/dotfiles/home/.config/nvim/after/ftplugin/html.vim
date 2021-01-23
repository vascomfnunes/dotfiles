setlocal iskeyword=@,48-57,_,-,\"
setlocal suffixesadd+=.html,.css,.txt,.js,.json
nmap <leader>cl :Dispatch html-linter %<cr>
