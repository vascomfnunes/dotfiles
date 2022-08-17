local ok, indent = pcall(require, 'indent_blankline')

if not ok then
  return
end

indent.setup {
  space_char_blankline = ' ',
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  buftype_exclude = { 'terminal' },
  filetype_exclude = {
    'help',
    'terminal',
    'packer',
    'mason',
    'lspinfo',
    'NvimTree',
  },
}
