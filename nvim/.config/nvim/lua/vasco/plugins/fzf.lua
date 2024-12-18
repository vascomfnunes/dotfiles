return {
  'ibhagwan/fzf-lua',
  event = 'BufWinEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { 'z=', '<cmd>FzfLua spell_suggest<cr>', desc = 'Spell suggestions' },
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Files' },
    { '<leader>fr', '<cmd>FzfLua resume<cr>', desc = 'Resume' },
    { '<leader>fc', '<cmd>FzfLua colorschemes<cr>', desc = 'Colorschemes' },
    { '<leader>fg', '<cmd>FzfLua live_grep<cr>', desc = 'Grep' },
    { '<leader>fG', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep string' },
    { '<leader>fd', '<cmd>FzfLua diagnostics_document<cr>', desc = 'LSP diagnostics' },
    { '<leader>fh', '<cmd>FzfLua helptags<cr>', desc = 'Help' },
    { '<leader>fq', '<cmd>FzfLua quickfix<cr>', desc = 'Quickfix' },
    {
      '<leader>fb',
      '<cmd>FzfLua buffers<cr>',
      desc = 'Buffers',
    },
  },
  config = function()
    local actions = require 'fzf-lua.actions'

    require('fzf-lua').setup {
      actions = {
        files = {
          -- instead of the default action 'actions.file_edit_or_qf'
          -- it's important to define all other actions here as this
          -- table does not get merged with the global defaults
          ['default'] = actions.file_edit,
          ['ctrl-s'] = actions.file_split,
          ['ctrl-v'] = actions.file_vsplit,
          ['ctrl-t'] = actions.file_tabedit,
          ['ctrl-q'] = {
            fn = actions.file_edit_or_qf,
            prefix = 'select-all+',
          },
        },
      },
      keymap = {
        fzf = {
          ['ctrl-j'] = 'down',
          ['ctrl-k'] = 'up',
        },
      },
    }
  end,
}
