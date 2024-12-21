return {
  'nvim-treesitter/nvim-treesitter',
  version = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    {
      'chrisgrieser/nvim-various-textobjs',
      config = function()
        require('various-textobjs').setup { useDefaults = false }
      end,
    },
    'RRethy/nvim-treesitter-endwise',
  },
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = { 'TSUpdateSync' },
  keys = {
    { '<leader>vt', vim.cmd.TSUpdate, desc = 'Update Treesitter definitions' },
  },
  config = function()
    require('nvim-dap-repl-highlights').setup()
    require('nvim-treesitter.configs').setup {
      auto_install = true,
      ensure_installed = { 'lua', 'dap_repl', 'regex' },
      highlight = { enable = true },
      indent = { enable = true },
      autotag = {
        enable = true,
      },
      autopairs = {
        enable = true,
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
