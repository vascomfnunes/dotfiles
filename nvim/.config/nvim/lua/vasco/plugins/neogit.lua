local icons = require 'vasco.utils.icons'

return {
  'NeogitOrg/neogit',
  dependencies = {
    {
      'sindrets/diffview.nvim',
      config = function()
        local actions = require 'diffview.actions'
        require('diffview').setup {
          keymaps = {
            view = {
              {
                'n',
                '<tab>',
                actions.select_next_entry,
                { desc = 'Open the diff for the next file' },
              },
              {
                'n',
                '<s-tab>',
                actions.select_prev_entry,
                { desc = 'Open the diff for the previous file' },
              },
              {
                'n',
                '[F',
                actions.select_first_entry,
                { desc = 'Open the diff for the first file' },
              },
              {
                'n',
                ']F',
                actions.select_last_entry,
                { desc = 'Open the diff for the last file' },
              },
              {
                'n',
                'gf',
                actions.goto_file_edit,
                { desc = 'Open the file in the previous tabpage' },
              },
              { 'n', '<C-w><C-f>', actions.goto_file_split, { desc = 'Open the file in a new split' } },
              { 'n', '<C-w>gf', actions.goto_file_tab, { desc = 'Open the file in a new tabpage' } },
              { 'n', '<leader>e', actions.focus_files, { desc = 'Bring focus to the file panel' } },
              { 'n', '<leader>b', actions.toggle_files, { desc = 'Toggle the file panel.' } },
              {
                'n',
                'g<C-x>',
                actions.cycle_layout,
                { desc = 'Cycle through available layouts.' },
              },
              {
                'n',
                '[x',
                actions.prev_conflict,
                { desc = 'In the merge-tool: jump to the previous conflict' },
              },
              {
                'n',
                ']x',
                actions.next_conflict,
                { desc = 'In the merge-tool: jump to the next conflict' },
              },
              {
                'n',
                '<leader>gco',
                actions.conflict_choose 'ours',
                { desc = 'Choose the OURS version of a conflict' },
              },
              {
                'n',
                '<leader>gct',
                actions.conflict_choose 'theirs',
                { desc = 'Choose the THEIRS version of a conflict' },
              },
              {
                'n',
                '<leader>gcb',
                actions.conflict_choose 'base',
                { desc = 'Choose the BASE version of a conflict' },
              },
              {
                'n',
                '<leader>gca',
                actions.conflict_choose 'all',
                { desc = 'Choose all the versions of a conflict' },
              },
              { 'n', 'dx', actions.conflict_choose 'none', { desc = 'Delete the conflict region' } },
              {
                'n',
                '<leader>gcO',
                actions.conflict_choose_all 'ours',
                { desc = 'Choose the OURS version of a conflict for the whole file' },
              },
              {
                'n',
                '<leader>gcT',
                actions.conflict_choose_all 'theirs',
                { desc = 'Choose the THEIRS version of a conflict for the whole file' },
              },
              {
                'n',
                '<leader>gcB',
                actions.conflict_choose_all 'base',
                { desc = 'Choose the BASE version of a conflict for the whole file' },
              },
              {
                'n',
                '<leader>gcA',
                actions.conflict_choose_all 'all',
                { desc = 'Choose all the versions of a conflict for the whole file' },
              },
              {
                'n',
                'dX',
                actions.conflict_choose_all 'none',
                { desc = 'Delete the conflict region for the whole file' },
              },
            },
          },
        }
      end,
    },
    'nvim-lua/plenary.nvim',
  },
  cmd = 'Neogit',
  keys = {
    { '<leader>gg', vim.cmd.Neogit, desc = 'Neogit' },
  },
  opts = {
    disable_signs = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = false,
    -- customize displayed signs
    signs = {
      -- { CLOSED, OPENED }
      section = { icons.right_arrow, icons.down_arrow },
      item = { icons.right_arrow, icons.down_arrow },
      hunk = { '', '' },
    },
    integrations = { diffview = true },
  },
}
