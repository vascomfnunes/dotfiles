vim.g.ultest_use_pty = 1
vim.g.ultest_virtual_text = 0
vim.g.ultest_pass_sign = '✔'
vim.g.ultest_fail_sign = '✖'
vim.g.ultest_not_run_sign = ''
vim.g.ultest_running_sign = ''

vim.api.nvim_exec(
  [[
        "let test#strategy = "neovim"
        let test#strategy = "dispatch"
        let test#neovim#term_position = "belowright"
        let g:test#preserve_screen = 1
        let test#ruby#rspec#runner = 'rspec'
        let test#ruby#cucumber#runner = 'cucumber'
        let test#javascript#jest#options = "--color=always"
        let test#javascript#reactscripts#options = "--watchAll=false"
        let test#ruby#rspec#options = {
          \ 'all': '--format progress --color'
          \}
    ]],
  false
)

require('ultest').setup {}
