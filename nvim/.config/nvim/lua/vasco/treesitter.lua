-- TREESITTER
--

local status_ok, treesitter = pcall(require, 'nvim-treesitter.configs')

if not status_ok then
  return
end

treesitter.setup {
  ensure_installed = {
    'bash',
    'c_sharp',
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
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
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
  endwise = {
    enable = true,
  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    colors = { '#e78a4e', '#ea6962', '#d3869b', '#7daea3', '#a9b665' }, -- table of hex strings
  },
}
