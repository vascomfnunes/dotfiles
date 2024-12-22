return {
  {
    'tpope/vim-rails',
    ft = { 'ruby', 'eruby' },
    dependencies = {
      'akinsho/toggleterm.nvim',
    },
    config = function()
      local Terminal = require('toggleterm.terminal').Terminal

      local function create_terminal(cmd)
        return Terminal:new {
          cmd = cmd,
          direction = 'horizontal',
          size = 15,
          on_open = function(term)
            vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
          end,
        }
      end

      local terminals = {
        rails_server = create_terminal 'bundle exec rails s',
        rails_console = create_terminal 'bundle exec rails c',
        guard = create_terminal 'bundle exec guard',
        overmind = create_terminal 'overmind s',
        overmind_connect = create_terminal 'overmind connect web',
      }

      -- Create global toggle functions
      for name, terminal in pairs(terminals) do
        _G[string.upper(name)] = function()
          terminal:toggle()
        end
      end
    end,
    keys = {
      { '<leader>rc', '<cmd>Econtroller<CR>', desc = 'Controller' },
      { '<leader>rv', '<cmd>Eview<CR>', desc = 'View' },
      { '<leader>rh', '<cmd>Ehelper<CR>', desc = 'Helper' },
      { '<leader>ra', '<cmd>A<CR>', desc = 'Alternate' },
      { '<leader>rl', '<cmd>Elocale<CR>', desc = 'Locale' },
      { '<leader>ru', '<cmd>Eunittest<CR>', desc = 'Unit test' },
      { '<leader>rm', '<cmd>Emodel<CR>', desc = 'Model' },
      { '<leader>rr', '<cmd>lua RAILS_SERVER()<CR>', desc = 'Rails Server' },
      { '<leader>ri', '<cmd>lua RAILS_CONSOLE()<CR>', desc = 'Rails Console' },
      { '<leader>ro', '<cmd>lua OVERMIND()<CR>', desc = 'Start overmind' },
      { '<leader>rC', '<cmd>lua OVERMIND_CONNECT()<CR>', desc = 'Overmind connect web' },
      { '<leader>rg', '<cmd>lua GUARD()<CR>', desc = 'Run Guard' },
    },
  },
}
