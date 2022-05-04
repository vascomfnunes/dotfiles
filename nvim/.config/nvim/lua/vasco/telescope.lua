-- TELESCOPE
--

local status_ok, telescope = pcall(require, 'telescope')

if not status_ok then
  return
end

local actions = require 'telescope.actions'

telescope.setup {
  defaults = {
    preview = { hide_on_startup = false },
    file_ignore_patterns = { 'node_modules', '.git', 'undo', 'tmp', 'fonts', 'images' },
    prompt_prefix = '❯ ',
    selection_caret = '❯ ',
    sorting_strategy = 'ascending',
    scroll_strategy = 'cycle',
    path_display = { 'absolute' },
    layout_config = { prompt_position = 'top' },
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<c-l>'] = actions.select_default + actions.center,
      },
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  },
}

telescope.load_extension 'fzy_native'
