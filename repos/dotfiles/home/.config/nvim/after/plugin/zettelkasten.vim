let g:zettelkasten = "/Users/vasco.nunes/zettelkasten/"
let g:diary = "/Users/vasco.nunes/zettelkasten/journal/"

" Create a new Zettel
function! NewZettel(...) abort
  " Make a unique filename
  let zettelname = g:zettelkasten . strftime("%Y%m%d-%H%M%S-") . join(a:000, '-') . '.md'
  execute "cd " . g:zettelkasten
  execute "edit " . zettelname

  if findfile(zettelname, ".") != zettelname
    execute "normal! i# " . toupper(join(a:000, ' '))
  endif
endfunction

command! -nargs=* NewZettel call NewZettel(<f-args>)
nnoremap <Leader>zn :NewZettel<space>

" Diary stuff
function! ZettelDiary(date_str) abort
  let diaryname = g:diary . a:date_str . '.md'
  execute "cd " . g:diary
  execute "edit " . diaryname

  if findfile(diaryname, ".") != diaryname
    execute "normal! i# " . a:date_str
    execute "read " . g:zettelkasten . "/assets/journal_template.md"
  endif
endfunction

" Make a new diary entry for today
command! -nargs=* ZettelDiaryToday call ZettelDiary(strftime("%d-%m-%Y"))
nnoremap <Leader>zd :ZettelDiaryToday<cr>

" Open index
function! ZettelEdit(filename) abort
  let index = g:zettelkasten . a:filename
  execute "cd " . g:zettelkasten
  execute "edit " . index
endfunction

command! -nargs=* ZettelIndex call ZettelEdit("index.md")
nnoremap <Leader>zi :ZettelIndex<cr>

" Open inbox
command! -nargs=* ZettelInbox call ZettelEdit("inbox.md")
nnoremap <Leader>zI :ZettelInbox<cr>
