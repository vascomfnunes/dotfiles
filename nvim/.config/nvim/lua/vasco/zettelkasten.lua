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
  template_new_note = home .. '/personal/templates/new_note.md',
  template_new_daily = home .. '/personal/templates/daily.md',
  template_new_weekly = home .. '/personal/templates/weekly.md',
  image_subdir = home .. '/personal/img',
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
      home = vim.fn.expand '~/notes/work',
      new_note_filename = 'uuid-title',
      uuid_type = '%d%m%Y%H%M',
      uuid_sep = '-',
      dailies = home .. '/work/daily',
      weeklies = home .. '/work/weekly',
      templates = home .. '/work/templates',
      image_subdir = home .. '/work/img',
      template_new_note = home .. '/work/templates/new_note.md',
      template_new_daily = home .. '/work/templates/daily.md',
      template_new_weekly = home .. '/work/templates/weekly.md',
    },
  },
}
