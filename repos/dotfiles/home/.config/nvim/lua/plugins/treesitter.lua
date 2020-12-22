require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
    disable = {"json"},
    use_languagetree = false
  }
}
