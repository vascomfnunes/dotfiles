return {
  'renerocksai/telekasten.nvim',
  cmd = 'Telekasten',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-telekasten/calendar-vim' },
  keys = {
    {
      '<leader>np',
      '<cmd>Telekasten panel<CR>',
      desc = 'Panel',
    },
    {
      '<leader>nf',
      '<cmd>Telekasten find_notes<CR>',
      desc = 'Find by title',
    },
    {
      '<leader>nT',
      '<cmd>Telekasten show_tags<CR>',
      desc = 'Tags',
    },
    {
      '<leader>ns',
      '<cmd>Telekasten search_notes<CR>',
      desc = 'Search with grep',
    },
    {
      '<leader>nt',
      '<cmd>Telekasten goto_today<CR>',
      desc = 'Today',
    },
    {
      '<leader>nn',
      '<cmd>Telekasten new_note<CR>',
      desc = 'New note',
    },
    {
      '<leader>ny',
      '<cmd>Telekasten yank_notelink<CR>',
      desc = 'Yank link to current note',
    },
    {
      '<leader>nc',
      '<cmd>Telekasten show_calendar<CR>',
      desc = 'Calendar',
    },
    {
      '<leader>nv',
      '<cmd>Telekasten switch_vault<CR>',
      desc = 'Switch vault',
    },
  },
  config = function()
    require('telekasten').setup {
      home = vim.fn.expand '~/notes',
      vaults = {
        personal = {
          home = vim.fn.expand '~/notes' .. '/vaults/personal',
        },
        work = {
          home = vim.fn.expand '~/notes' .. '/vaults/work',
        },
        inbox = {
          home = vim.fn.expand '~/notes' .. '/vaults/inbox',
        },
      },
    }
  end,
}
