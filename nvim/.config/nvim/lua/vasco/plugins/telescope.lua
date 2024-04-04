return {
  'nvim-telescope/telescope.nvim',
  cmd = { 'Telescope' },
  dependencies = {
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
    'tsakirist/telescope-lazy.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
  },
  keys = {
    { 'z=', '<cmd>Telescope spell_suggest<cr>', desc = 'Spell suggestions' },
    { '<leader>ff', '<cmd>Telescope find_files hidden=true<cr>', desc = 'Files' },
    { '<leader>fr', '<cmd>Telescope resume<cr>', desc = 'Resume' },
    { '<leader>fn', '<cmd>Telescope noice<cr>', desc = 'Noice' },
    { '<leader>fc', '<cmd>Telescope colorscheme<cr>', desc = 'Colorschemes' },
    { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Grep' },
    { '<leader>fG', '<cmd>Telescope grep_string<cr>', desc = 'Grep string' },
    { '<leader>fd', '<cmd>Telescope diagnostics<cr>', desc = 'LSP diagnostics' },
    { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Help' },
    { '<leader>fq', '<cmd>Telescope quickfix<cr>', desc = 'Quickfix' },
    { '<leader>fp', '<cmd>Telescope lazy<cr>', desc = 'Plugins' },
    {
      '<leader>fb',
      '<cmd>Telescope buffers ignore_current_buffer=true sort_mru=true<cr>',
      desc = 'Buffers',
    },
    {
      '<leader><space>',
      '<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>',
      desc = 'File browser',
    },
  },
  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'
    local icons = require 'vasco.utils.icons'

    telescope.setup {
      defaults = {
        color_devicons = true,
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
          '--glob=!.git/',
        },
        prompt_prefix = icons.search,
        entry_prefix = '   ',
        preview = { hide_on_startup = false },
        file_ignore_patterns = { 'node_modules', '.git', 'undo', 'tmp', 'fonts', 'images', 'public' },
        selection_caret = '❯ ',
        selection_strategy = 'reset',
        sorting_strategy = 'ascending',
        scroll_strategy = 'cycle',
        file_sorter = require('telescope.sorters').get_fuzzy_file,
        generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
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
          file_browser = {
            theme = 'ivy',
            hijack_netrw = true,
            mappings = {
              ['i'] = {
                ['<C-l>'] = require('telescope').extensions.file_browser.actions.open,
                ['<C-h>'] = require('telescope').extensions.file_browser.actions.goto_parent_dir,
              },
              ['n'] = {
                ['<C-l>'] = require('telescope').extensions.file_browser.actions.open,
                ['<C-h>'] = require('telescope').extensions.file_browser.actions.goto_parent_dir,
              },
            },
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case". the default case_mode is "smart_case"
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
          },
        },
      },
    }

    telescope.load_extension 'fzf'
    telescope.load_extension 'noice'
    telescope.load_extension 'lazy'
    telescope.load_extension 'file_browser'
  end,
}
