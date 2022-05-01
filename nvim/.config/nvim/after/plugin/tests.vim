let test#strategy = "neovim"

" Ruby
let test#ruby#rspec#runner = 'rspec'
let test#ruby#cucumber#runner = 'cucumber'
" let test#ruby#rspec#executable = '~/bin/rspec_no_warnings'
let test#ruby#cucumber#executable = 'bundle exec cucumber'
let test#javascript#jest#options = "--color=always"
let test#ruby#rspec#options = {
      \ 'all': '--format progress --color'
      \}
