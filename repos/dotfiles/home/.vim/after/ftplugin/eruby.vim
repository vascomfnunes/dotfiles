setlocal expandtab shiftwidth=2 tabstop=2

" ERB tags
let g:surround_45 = "<% \r %>"
let g:surround_61 = "<%= \r %>"
let g:surround_33 = "```\r```"

" Add the '-' as a keyword in erb files
setlocal iskeyword=@,48-57,_,192-255,$,-,@-@
setlocal foldmethod=syntax
