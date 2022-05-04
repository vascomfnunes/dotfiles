-- TREESITTER
--

local status_ok, treesitter = pcall(require, 'nvim-treesitter.configs')

if not status_ok then
  return
end

treesitter.setup {
  ensure_installed = {
    'bash',
    'c',
    'css',
    'dockerfile',
    'go',
    'graphql',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'lua',
    'markdown',
    'regex',
    'ruby',
    'scss',
    'tsx',
    'typescript',
    'vim',
    'yaml',
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'tt',
      node_incremental = 'tl',
      scope_incremental = 'tj',
      node_decremental = 'th',
    },
  },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
  autopairs = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}
