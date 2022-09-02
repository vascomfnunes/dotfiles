local ok, indent = pcall(require, 'indent_blankline')

if not ok then
  return
end

indent.setup {
  space_char_blankline = ' ',
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  filetype_exclude = {
    'terminal',
    'packer',
    'mason',
    'lspinfo',
    'markdown',
    'json',
    'txt',
    'help',
    'NvimTree',
    'git',
    'TelescopePrompt',
    'TelescopeResults',
  },
  buftype_exclude = { 'terminal' },
  char_list = { '┊' },
  show_current_context = true,
  show_current_context_start = false,
  context_patterns = {
    'class',
    'function',
    'method',
    'block',
    'list_literal',
    'selector',
    '^if',
    '^table',
    'if_statement',
    'while',
    'for',
  },
}
