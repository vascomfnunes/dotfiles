return {
  -- fd and ripgrep are required
  'nvim-telescope/telescope.nvim',
  cmd = { 'Telescope' },
  dependencies = {
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
    'tsakirist/telescope-lazy.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
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
    { '<leader>fs', '<cmd>Telescope lsp_document_symbols<cr>', desc = 'Document Symbols' },
    { '<leader>fS', '<cmd>Telescope lsp_workspace_symbols<cr>', desc = 'Workspace Symbols' },
    { '<leader>ft', '<cmd>Telescope treesitter<cr>', desc = 'Treesitter Symbols' },
    {
      '<leader>fb',
      '<cmd>Telescope buffers ignore_current_buffer=true sort_mru=true<cr>',
      desc = 'Buffers',
    },
    {
      '<leader><space>',
      function()
        require('telescope').extensions.file_browser.file_browser {
          path = vim.fn.expand '%:p:h',
          select_buffer = true,
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          initial_mode = 'insert',
          layout_strategy = 'bottom_pane',
          layout_config = {
            bottom_pane = {
              height = 0.5,
              preview_cutoff = 120,
              prompt_position = 'bottom',
            },
          },
        }
      end,
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
        prompt_prefix = icons.search .. ' ',
        selection_caret = icons.arrow_right .. ' ',
        entry_prefix = '   ',
        initial_mode = 'insert',
        selection_strategy = 'reset',
        sorting_strategy = 'ascending',
        layout_strategy = 'horizontal',
        preview = {
          hide_on_startup = false,
          filesize_limit = 1,
          timeout = 250,
        },
        file_ignore_patterns = {
          'node_modules',
          '.git/',
          'undo/',
          'tmp/',
          'fonts/',
          'images/',
          'public/',
          '%.lock',
          '%.sqlite3',
          '%.svg',
          '%.otf',
          '%.ttf',
          '__pycache__',
        },
        path_display = { truncate = 3 },
        winblend = 0,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        set_env = { ['COLORTERM'] = 'truecolor' },
        layout_config = {
          horizontal = {
            prompt_position = 'top',
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-n>'] = actions.cycle_history_next,
            ['<C-p>'] = actions.cycle_history_prev,
            ['<C-c>'] = actions.close,
            ['<C-u>'] = actions.preview_scrolling_up,
            ['<C-d>'] = actions.preview_scrolling_down,
            ['<C-l>'] = function(prompt_bufnr)
              actions.select_default(prompt_bufnr)
              actions.center(prompt_bufnr)
            end,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix', '--no-ignore', '--no-ignore-vcs' },
        },
        live_grep = {
          additional_args = function()
            return { '--hidden' }
          end,
        },
      },
      extensions = {
        file_browser = {
          hijack_netrw = true,
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          initial_mode = 'insert',
          select_buffer = true,
          use_last_dir = true,
          dir_icon = '',
          dir_icon_hl = 'Default',
          display_stat = { date = true, size = true },
          path = '%:p:h',
          layout_strategy = 'bottom_pane',
          layout_config = {
            bottom_pane = {
              height = 0.5,
              preview_cutoff = 120,
              prompt_position = 'bottom',
            },
          },
          mappings = {
            ['i'] = {
              ['<C-l>'] = require('telescope.actions').select_default,
              ['<C-h>'] = require('telescope').extensions.file_browser.actions.goto_parent_dir,
              ['<C-n>'] = require('telescope').extensions.file_browser.actions.create,
              ['<C-r>'] = require('telescope').extensions.file_browser.actions.rename,
              ['<C-m>'] = require('telescope').extensions.file_browser.actions.move,
              ['<C-d>'] = require('telescope').extensions.file_browser.actions.remove,
              ['<C-j>'] = require('telescope.actions').move_selection_next,
              ['<C-k>'] = require('telescope.actions').move_selection_previous,
              ['<tab>'] = require('telescope.actions').toggle_selection,
            },
            ['n'] = {
              ['<C-l>'] = require('telescope.actions').select_default,
              ['<C-h>'] = require('telescope').extensions.file_browser.actions.goto_parent_dir,
              ['<C-n>'] = require('telescope').extensions.file_browser.actions.create,
              ['<C-r>'] = require('telescope').extensions.file_browser.actions.rename,
              ['<C-m>'] = require('telescope').extensions.file_browser.actions.move,
              ['<C-d>'] = require('telescope').extensions.file_browser.actions.remove,
              ['<C-j>'] = require('telescope.actions').move_selection_next,
              ['<C-k>'] = require('telescope.actions').move_selection_previous,
              ['<tab>'] = require('telescope.actions').toggle_selection,
            },
          },
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown {},
        },
        lazy = {
          theme = 'ivy',
          show_icon = true,
          mappings = {
            open_in_browser = '<C-o>',
            open_in_file_browser = '<M-b>',
            open_in_find_files = '<C-f>',
            open_in_live_grep = '<C-g>',
            open_plugins_picker = '<C-b>',
            open_lazy_root_find_files = '<C-r>f',
            open_lazy_root_live_grep = '<C-r>g',
          },
        },
      },
    }

    -- Load extensions
    telescope.load_extension 'fzf'
    telescope.load_extension 'noice'
    telescope.load_extension 'lazy'
    telescope.load_extension 'file_browser'
    telescope.load_extension 'ui-select'
  end,
}
