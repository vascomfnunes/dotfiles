vim.cmd[[packadd nvim-treesitter]]

require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  highlight = {enable = true, use_languagetree = true},
  indent = {
    enable = true,
  },
  lsp_interop = {
      enable = true,
  },
  refactor = {highlight_definitions = {enable = true}, highlight_current_scope = {enable = true}}
}
