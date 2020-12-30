require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  highlight = {enable = true},
  refactor = {highlight_definitions = {enable = true}, highlight_current_scope = {enable = true}}
}
