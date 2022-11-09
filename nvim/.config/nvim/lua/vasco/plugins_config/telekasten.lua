local personal = vim.fn.expand '~/notes'
local work = vim.fn.expand '~/workspace/notes'

require('telekasten').setup {
  home = personal,
  dailies = personal .. '/daily',
  weeklies = personal .. '/weekly',
  templates = personal .. '/templates',
  template_new_note = personal .. '/templates/new_note.md',
  template_new_daily = personal .. '/templates/daily.md',
  template_new_weekly = personal .. '/templates/weekly.md',
  image_subdir = personal .. '/img',
  take_over_my_home = true,
  auto_set_filetype = false,
  extension = '.md',
  new_note_filename = 'uuid-title',
  uuid_type = '%d%m%Y%H%M',
  uuid_sep = '-',
  command_palette_theme = 'dropdown',
  media_previewer = 'catimg-previewer', -- requires 'brew install catimg'
  vaults = {
    work = {
      home = work,
      new_note_filename = 'uuid-title',
      uuid_type = '%d%m%Y%H%M',
      uuid_sep = '-',
      dailies = work .. '/daily',
      weeklies = work .. '/weekly',
      templates = work .. '/templates',
      image_subdir = work .. '/img',
      template_new_note = work .. '/templates/new_note.md',
      template_new_daily = work .. '/templates/daily.md',
      template_new_weekly = work .. '/templates/weekly.md',
    },
  },
}
