local M = {
  'nvim-treesitter/nvim-treesitter',
}

M.dependencies = {
  'nvim-treesitter/nvim-treesitter-textobjects',
  {
    'chrisgrieser/nvim-various-textobjs',
    config = function()
      require('various-textobjs').setup { useDefaultKeymaps = true }
      -- indentation: ii,ai,aI,ci
      -- value: iv,av
      -- key: ik,ak
      -- number: in,an
      -- nearEoL: n
      -- markdown link: il,al
      -- css selector: ic,ac
      -- rest of paragraph: r
      -- entire buffer: gG
      -- url: L
      -- complete objects table: https://github.com/chrisgrieser/nvim-various-textobjs#list-of-text-objects
    end,
  },
  'JoosepAlviste/nvim-ts-context-commentstring',
  'RRethy/nvim-treesitter-endwise',
  'mrjones2014/nvim-ts-rainbow',
}

M.build = ':TSUpdate'
M.event = 'BufEnter'

function M.config()
  local colors = require 'vasco.helpers.colors'

  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      'bash',
      'c_sharp',
      'css',
      'dockerfile',
      'go',
      'rust',
      'sql',
      'graphql',
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
    rainbow = {
      enable = true,
      -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = nil, -- Do not enable for files with more than n lines, int
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
        border = 'rounded',
        peek_definition_code = {
          ['<leader>cpf'] = '@function.outer',
          ['<leader>cpc'] = '@class.outer',
        },
      },
    },
  }
end

return M
