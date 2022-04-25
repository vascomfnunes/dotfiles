function! s:expand_commit_template() abort
  let context = {
        \ 'MY_BRANCH': matchstr(system('git rev-parse --abbrev-ref HEAD | cut -d "/" -f1'), '\p\+'),
        \ }

  let lnum = nextnonblank(1)
  while lnum && lnum < line('$')
    call setline(lnum, substitute(getline(lnum), '\${\(\w\+\)}',
          \ '\=get(context, submatch(1), submatch(0))', 'g'))
    let lnum = nextnonblank(lnum + 1)
  endwhile
endfunction

autocmd BufRead */.git/COMMIT_EDITMSG call s:expand_commit_template()
