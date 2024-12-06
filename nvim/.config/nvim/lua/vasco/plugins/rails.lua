return {
  {
    'tpope/vim-rails',
    ft = { 'ruby', 'eruby' },
    dependencies = {
      'akinsho/toggleterm.nvim',
    },
    config = function()
      local Terminal = require('toggleterm.terminal').Terminal

      -- Create specific runners for Rails commands
      local rails_server = Terminal:new {
        cmd = 'bundle exec rails s',
        direction = 'horizontal',
        size = 15,
        on_open = function(term)
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
      }

      local rails_console = Terminal:new {
        cmd = 'bundle exec rails c',
        direction = 'horizontal',
        size = 15,
        on_open = function(term)
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
      }

      local overmind = Terminal:new {
        cmd = 'overmind s',
        direction = 'horizontal',
        size = 15,
        on_open = function(term)
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
      }

      local overmind_connect = Terminal:new {
        cmd = 'overmind connect web',
        direction = 'horizontal',
        size = 15,
        on_open = function(term)
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
      }

      -- Functions to toggle specific terminals
      function _RAILS_SERVER()
        rails_server:toggle()
      end

      function _RAILS_CONSOLE()
        rails_console:toggle()
      end
      function _OVERMIND()
        overmind:toggle()
      end
      function _OVERMIND_CONNECT()
        overmind_connect:toggle()
      end
    end,
    keys = {
      -- Your existing mappings
      {
        '<leader>rc',
        '<cmd>Econtroller<CR>',
        desc = 'Controller',
      },
      {
        '<leader>rv',
        '<cmd>Eview<CR>',
        desc = 'View',
      },
      {
        '<leader>rh',
        '<cmd>Ehelper<CR>',
        desc = 'Helper',
      },
      {
        '<leader>ra',
        '<cmd>A<CR>',
        desc = 'Alternate',
      },
      {
        '<leader>rl',
        '<cmd>Elocale<CR>',
        desc = 'Locale',
      },
      {
        '<leader>ru',
        '<cmd>Eunittest<CR>',
        desc = 'Unit test',
      },
      {
        '<leader>rm',
        '<cmd>Emodel<CR>',
        desc = 'Model',
      },
      -- New mappings for Rails server and console
      {
        '<leader>rr',
        '<cmd>lua _RAILS_SERVER()<CR>',
        desc = 'Rails Server',
      },
      {
        '<leader>ri',
        '<cmd>lua _RAILS_CONSOLE()<CR>',
        desc = 'Rails Console',
      },
      {
        '<leader>ro',
        '<cmd>lua _OVERMIND()<CR>',
        desc = 'Start overmind',
      },
      {
        '<leader>rC',
        '<cmd>lua _OVERMIND_CONNECT()<CR>',
        desc = 'Overmind connect web',
      },
    },
  },
}
