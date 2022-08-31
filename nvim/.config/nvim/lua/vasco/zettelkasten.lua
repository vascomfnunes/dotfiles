local status_ok, telekasten = pcall(require, 'telekasten')

if not status_ok then
  return
end

local home = vim.fn.expand '~/notes'

telekasten.setup {
  home = vim.fn.expand '~/notes/personal',
  dailies = home .. '/personal/daily',
  weeklies = home .. '/personal/weekly',
  templates = home .. '/personal/templates',
  image_subdir = home .. '/personal/img',
  take_over_my_home = true,
  auto_set_filetype = false,
  extension = '.md',
  new_note_filename = 'uuid-title',
  uuid_type = '%d%m%Y%H%M',
  uuid_sep = '-',
  media_previewer = 'telescope-media-files',
  vaults = {
    work = {
      home = vim.fn.expand '~/notes/work',
      new_note_filename = 'uuid-title',
      uuid_type = '%d%m%Y%H%M',
      uuid_sep = '-',
      dailies = home .. '/work/daily',
      weeklies = home .. '/work/weekly',
      templates = home .. '/work/templates',
      image_subdir = home .. '/work/img',
    },
  },
}
