return {
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<c-j>', '<c-j>', ft = 'fzf', mode = 't', nowait = true },
    { '<c-k>', '<c-k>', ft = 'fzf', mode = 't', nowait = true },
    { 'z=', '<cmd>FzfLua spell_suggest<cr>', desc = 'Spell suggestions' },
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Files' },
    { '<leader>fr', '<cmd>FzfLua resume<cr>', desc = 'Resume' },
    { '<leader>fc', '<cmd>FzfLua colorschemes<cr>', desc = 'Colorschemes' },
    { '<leader>fg', '<cmd>FzfLua live_grep<cr>', desc = 'Grep' },
    { '<leader>fG', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep string' },
    { '<leader>fv', '<cmd>FzfLua grep_visual<cr>', desc = 'Grep visual' },
    { '<leader>fd', '<cmd>FzfLua diagnostics_document<cr>', desc = 'LSP diagnostics' },
    { '<leader>fh', '<cmd>FzfLua helptags<cr>', desc = 'Help' },
    { '<leader>fq', '<cmd>FzfLua quickfix<cr>', desc = 'Quickfix' },
    -- { '<leader>gg', '<cmd>FzfLua git_status<cr>', desc = 'Git status' },
    -- { '<leader>gc', '<cmd>FzfLua git_commits<cr>', desc = 'Git commits' },
    -- { '<leader>gB', '<cmd>FzfLua git_branches<cr>', desc = 'Git branches' },
    -- { '<leader>gs', '<cmd>FzfLua git_stash<cr>', desc = 'Git stash' },
    {
      '<leader>fb',
      '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>',
      desc = 'Buffers',
    },
  },
  opts = function()
    local config = require 'fzf-lua.config'
    local actions = require 'fzf-lua.actions'

    -- Quickfix
    config.defaults.keymap.fzf['ctrl-q'] = 'select-all+accept'
    config.defaults.keymap.fzf['ctrl-u'] = 'half-page-up'
    config.defaults.keymap.fzf['ctrl-d'] = 'half-page-down'
    config.defaults.keymap.fzf['ctrl-x'] = 'jump'
    config.defaults.keymap.fzf['ctrl-f'] = 'preview-page-down'
    config.defaults.keymap.fzf['ctrl-b'] = 'preview-page-up'
    config.defaults.keymap.builtin['<c-f>'] = 'preview-page-down'
    config.defaults.keymap.builtin['<c-b>'] = 'preview-page-up'

    return {
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
  config = function(_, opts)
    require('fzf-lua').setup(opts)
  end,
}
