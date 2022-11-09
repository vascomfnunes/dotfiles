require('lualine').setup {
  options = {
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename', 'diagnostics', 'diff', 'g:coc_status' },
    lualine_x = { 'searchcount', 'filesize', 'encoding', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  }
}
