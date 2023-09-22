local config = require 'vasco.config'

return {
  'nvim-treesitter/nvim-treesitter',
  version = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    {
      'chrisgrieser/nvim-various-textobjs',
      config = function()
        require('various-textobjs').setup { useDefaultKeymaps = true }
      end,
    },
    'JoosepAlviste/nvim-ts-context-commentstring',
    'RRethy/nvim-treesitter-endwise',
  },
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = { 'TSUpdateSync' },
  keys = {
    vim.keymap.set('n', '<leader>ut', vim.cmd.TSUpdate, { desc = 'Treesitter definitions' }),
  },
  config = function()
    require('nvim-treesitter.configs').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        'bash',
        'css',
        'dockerfile',
        'sql',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'lua',
        'regex',
        'ruby',
        'scss',
        'tsx',
        'typescript',
        'vim',
        'yaml',
        'markdown',
        'markdown_inline',
        'latex',
        'commonlisp',
      },

      highlight = { enable = true },
      indent = { enable = true },
      autotag = {
        enable = true,
      },
      autopairs = {
        enable = true,
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      endwise = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<cr>',
          node_incremental = '<cr>',
          node_decremental = '<backspace>',
        },
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
      },
    }
  end,
}
