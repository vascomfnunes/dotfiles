local M = {
  'nvim-neotest/neotest',
}

M.dependencies = {
  'olimorris/neotest-rspec',
  'nvim-lua/plenary.nvim',
  'nvim-treesitter/nvim-treesitter',
  'haydenmeade/neotest-jest',
}

M.ft = { 'ruby', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'rust', 'go', 'cs', 'lua' }

function M.config()
  local neotest = require 'neotest'
  local icons = require 'vasco.helpers.icons'

  neotest.setup {
    adapters = {
      require 'neotest-jest' {
        jestCommand = 'yarn jest',
      },
      require 'neotest-rspec',
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
end

return M
