-- GENERAL
--

-- Disable filetype plugin, use the new Lua version
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- Custom filetype detection logic with the new Lua filetype plugin
vim.filetype.add {
  extension = {
    png = 'image',
    jpg = 'image',
    jpeg = 'image',
    gif = 'image',
    es6 = 'javascript',
  },
  filename = {
    ['.eslintrc'] = 'json',
    ['.prettierrc'] = 'json',
    ['.babelrc'] = 'json',
    ['.stylelintrc'] = 'json',
  },
  pattern = {
    ['.*config/git/config'] = 'gitconfig',
    ['.env.*'] = 'sh',
  },
}

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable some builtin vim plugins
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

-- Disable unused providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_pearl_provider = 0

-- Python provider
vim.g.python3_host_prog = '/usr/local/bin/python3'
