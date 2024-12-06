return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-neotest/nvim-nio',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-jest',
    'zidhuss/neotest-minitest',
    'olimorris/neotest-rspec',
  },
  ft = { 'ruby', 'ruby.rails', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  keys = {
    {
      '<leader>Tn',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run nearest test',
    },
    {
      '<leader>Tf',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = 'Run file tests',
    },
    {
      '<leader>TS',
      function()
        require('neotest').run.stop()
      end,
      desc = 'Stop',
    },
    {
      '<leader>Ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle tests summary',
    },
    {
      '<leader>To',
      function()
        require('neotest').output.open { enter = true }
      end,
      desc = 'Show test output',
    },
  },
  config = function()
    local neotest = require 'neotest'
    local icons = require 'vasco.utils.icons'

    neotest.setup {
      log_level = 1,
      default_strategy = 'integrated',
      consumers = {},
      adapters = {
        require 'neotest-jest' {
          jestCommand = 'yarn jest',
          jestConfigFile = 'jest.config.js',
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
          jest_test_discovery = {
            filter_dir = function(name)
              return name ~= 'node_modules'
            end,
          },
        },
        require 'neotest-rspec' {
          commands_values = {
            'bundle exec rspec',
          },
        },
        require 'neotest-minitest' {
          test_cmd = function()
            return vim.tbl_flatten {
              'bundle',
              'exec',
              'rails',
              'test',
            }
          end,
          test_file_pattern = '.*_test%.rb$',
          is_test_file = function(file_path)
            return vim.endswith(file_path, '_test.rb')
          end,
          frameworks = {
            'minitest',
          },
        },
      },
      discovery = {
        enabled = true,
        concurrent = 2,
      },
      diagnostic = {
        enabled = true,
        severity = 1,
      },
      floating = {
        border = 'rounded',
        max_height = 0.6,
        max_width = 0.6,
        options = {},
      },
      highlights = {
        adapter_name = 'NeotestAdapterName',
        border = 'NeotestBorder',
        dir = 'NeotestDir',
        expand_marker = 'NeotestExpandMarker',
        failed = 'NeotestFailed',
        file = 'NeotestFile',
        focused = 'NeotestFocused',
        indent = 'NeotestIndent',
        namespace = 'NeotestNamespace',
        passed = 'NeotestPassed',
        running = 'NeotestRunning',
        skipped = 'NeotestSkipped',
        test = 'NeotestTest',
      },
      icons = {
        child_indent = '│',
        child_prefix = '├',
        collapsed = '─',
        expanded = '╮',
        failed = icons.error,
        final_child_indent = ' ',
        final_child_prefix = '╰',
        non_collapsible = '─',
        passed = icons.check,
        running = icons.cog,
        skipped = icons.skip,
        unknown = icons.question,
      },
      output = {
        enabled = true,
        open_on_run = true,
      },
      output_panel = {
        enabled = true,
        open = 'botright split | resize 15',
      },
      projects = {},
      quickfix = {
        enabled = true,
        open = false,
      },
      run = {
        enabled = true,
      },
      running = {
        concurrent = true,
      },
      state = {
        enabled = true,
      },
      status = {
        enabled = true,
        signs = true,
        virtual_text = true,
      },
      strategies = {
        integrated = {
          height = 40,
          width = 120,
        },
      },
      summary = {
        animated = true,
        enabled = true,
        count = true,
        expand_errors = true,
        follow = true,
        mappings = {
          attach = 'a',
          clear_marked = 'M',
          clear_target = 'T',
          debug = 'd',
          debug_marked = 'D',
          expand = { '<CR>', '<2-LeftMouse>' },
          expand_all = 'e',
          jumpto = 'l',
          mark = 'm',
          next_failed = 'J',
          output = 'o',
          prev_failed = 'K',
          run = 'r',
          run_marked = 'R',
          short = 'O',
          stop = 'u',
          target = 't',
          watch = 'w',
        },
        open = 'botright vsplit | vertical resize 50',
      },
      watch = {
        enabled = true,
        symbol_queries = {
          'function_declaration',
          'method_declaration',
          'class_declaration',
          'test_case',
        },
      },
    }
  end,
}
