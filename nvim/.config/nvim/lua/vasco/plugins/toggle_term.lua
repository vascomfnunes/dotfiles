return {
  {
    'akinsho/toggleterm.nvim',
    event = 'BufWinEnter',
    version = '*',
    config = function()
      require('toggleterm').setup {
        size = 20,
        direction = 'horizontal',
        shade_terminals = false,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        highlights = {
          Normal = {
            link = 'Normal',
          },
          NormalFloat = {
            link = 'Normal',
          },
        },
        -- on_open = function(term)
        --   vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
        -- end,
      }

      vim.api.nvim_set_keymap(
        'n',
        '<leader>tn',
        '<cmd>ToggleTerm direction=horizontal<CR>',
        { noremap = true, silent = true, desc = 'New Terminal' }
      )
      vim.api.nvim_set_keymap(
        't',
        '<leader>tn',
        '<cmd>ToggleTerm direction=horizontal<CR>',
        { noremap = true, silent = true, desc = 'New Terminal' }
      )

      -- Toggle all terminals
      vim.api.nvim_set_keymap(
        'n',
        '<C-t>',
        '<cmd>ToggleTermToggleAll<CR>',
        { noremap = true, silent = true, desc = 'Toggle All Terminals' }
      )
      vim.api.nvim_set_keymap(
        't',
        '<C-t>',
        '<cmd>ToggleTermToggleAll<CR>',
        { noremap = true, silent = true, desc = 'Toggle All Terminals' }
      )

      -- Terminal navigation
      vim.api.nvim_set_keymap(
        't',
        '<C-h>',
        [[<C-\><C-n><cmd>wincmd h<CR>]],
        { noremap = true, silent = true, desc = 'Navigate left' }
      )
      vim.api.nvim_set_keymap(
        't',
        '<C-j>',
        [[<C-\><C-n><cmd>wincmd j<CR>]],
        { noremap = true, silent = true, desc = 'Navigate down' }
      )
      vim.api.nvim_set_keymap(
        't',
        '<C-k>',
        [[<C-\><C-n><cmd>wincmd k<CR>]],
        { noremap = true, silent = true, desc = 'Navigate up' }
      )
      vim.api.nvim_set_keymap(
        't',
        '<C-l>',
        [[<C-\><C-n><cmd>wincmd l<CR>]],
        { noremap = true, silent = true, desc = 'Navigate right' }
      )

      -- Terminal switching
      vim.api.nvim_set_keymap(
        'n',
        '<leader>1',
        '<cmd>1ToggleTerm<CR>',
        { noremap = true, silent = true, desc = 'Terminal 1' }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>2',
        '<cmd>2ToggleTerm<CR>',
        { noremap = true, silent = true, desc = 'Terminal 2' }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>3',
        '<cmd>3ToggleTerm<CR>',
        { noremap = true, silent = true, desc = 'Terminal 3' }
      )

      -- Terminal mode switching
      vim.api.nvim_set_keymap(
        't',
        '<leader>1',
        '<cmd>1ToggleTerm<CR>',
        { noremap = true, silent = true, desc = 'Terminal 1' }
      )
      vim.api.nvim_set_keymap(
        't',
        '<leader>2',
        '<cmd>2ToggleTerm<CR>',
        { noremap = true, silent = true, desc = 'Terminal 2' }
      )
      vim.api.nvim_set_keymap(
        't',
        '<leader>3',
        '<cmd>3ToggleTerm<CR>',
        { noremap = true, silent = true, desc = 'Terminal 3' }
      )
    end,
  },
}
