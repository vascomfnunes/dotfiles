local M = {
  'nvim-telescope/telescope.nvim',
}

M.dependencies = {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  },
  'jedrzejboczar/possession.nvim',
  'tsakirist/telescope-lazy.nvim',
}

M.cmd = { 'Telescope' }

function M.config()
  local telescope = require 'telescope'
  local actions = require 'telescope.actions'
  local icons = require 'vasco.helpers.icons'

  telescope.setup {
    defaults = {
      prompt_prefix = icons.search,
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
      extensions = {
        fzf = {
          fuzzy = true,
        },
        lazy = {
          -- Optional theme (the extension doesn't set a default theme)
          theme = 'ivy',
          -- Whether or not to show the icon in the first column
          show_icon = true,
          -- Mappings for the actions
          mappings = {
            open_in_browser = '<C-o>',
            open_in_file_browser = '<M-b>',
            open_in_find_files = '<C-f>',
            open_in_live_grep = '<C-g>',
            open_plugins_picker = '<C-b>', -- Works only after having called first another action
            open_lazy_root_find_files = '<C-r>f',
            open_lazy_root_live_grep = '<C-r>g',
          },
          -- Other telescope configuration options
        },
      },
    },
  }

  telescope.load_extension 'fzf'
  telescope.load_extension 'possession'
  telescope.load_extension 'noice'
  telescope.load_extension 'lazy'
end

return M
