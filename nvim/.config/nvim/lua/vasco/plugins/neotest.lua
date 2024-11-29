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
  ft = { 'ruby', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  keys = {
    {
      '<leader>tn',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run nearest test',
    },
    {
      '<leader>tf',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = 'Run file tests',
    },
    {
      '<leader>tS',
      function()
        require('neotest').run.stop()
      end,
      desc = 'Stop',
    },
    {
      '<leader>ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle tests summary',
    },
    {
      '<leader>to',
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
      adapters = {
        require 'neotest-jest' {
          jestCommand = 'yarn jest',
        },
        require 'neotest-rspec' {
          rspec_cmd = function()
            return vim.tbl_flatten {
              'bundle',
              'exec',
              'rspec',
            }
          end,
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
        },
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
      summary = {
        enabled = true,
        expand_errors = true,
        follow = true,
        mappings = {
          attach = 'a',
          expand = { '<CR>', '<2-LeftMouse>' },
          expand_all = 'e',
          jumpto = 'l',
          output = 'o',
          run = 'r',
          short = 'O',
          stop = 'u',
        },
      },
    }
  end,
}
