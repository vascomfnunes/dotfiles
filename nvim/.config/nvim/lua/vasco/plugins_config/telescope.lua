local actions = require 'telescope.actions'

require('telescope').setup {
  defaults = {
    prompt_prefix = '   ',
    preview = { hide_on_startup = false },
    file_ignore_patterns = { 'node_modules', '.git', 'undo', 'tmp', 'fonts', 'images', 'public' },
    selection_caret = '❯ ',
    sorting_strategy = 'ascending',
    scroll_strategy = 'cycle',
    path_display = { 'truncate' },
    winblend = 0,
    set_env = { ['COLORTERM'] = 'truecolor' },
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<c-l>'] = actions.select_default + actions.center,
      },
    },
    extensions = {},
  },
}
