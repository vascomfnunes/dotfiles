local config = require 'vasco.config'

return {
  'nvim-treesitter/nvim-treesitter',
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
  event = 'BufEnter',
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
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
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
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
        lsp_interop = {
          enable = true,
          border = config.border_style,
          peek_definition_code = {
            ['<leader>cpf'] = '@function.outer',
            ['<leader>cpc'] = '@class.outer',
          },
        },
      },
    }
  end,
}
