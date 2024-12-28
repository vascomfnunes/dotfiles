return {
  {
    'tpope/vim-rails',
    ft = { 'ruby', 'eruby' },
    dependencies = {
      'akinsho/toggleterm.nvim',
    },
    config = function()
      local Terminal = require('toggleterm.terminal').Terminal

      -- Terminal creation function
      local function create_terminal(cmd, opts)
        return Terminal:new(vim.tbl_extend('force', {
          cmd = cmd,
          direction = 'horizontal',
          size = 15,
          hidden = true,
          close_on_exit = true,
          auto_scroll = true,
          on_open = function(term)
            vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
            vim.api.nvim_buf_set_keymap(term.bufnr, 'n', '<Esc>', '<cmd>close<CR>', { noremap = true, silent = true })
          end,
        }, opts or {}))
      end

      -- Safe toggle function with error handling
      local function safe_toggle(terminal, name)
        local ok, err = pcall(function()
          terminal:toggle()
        end)
        if not ok then
          vim.notify('Failed to toggle ' .. name .. ': ' .. err, vim.log.levels.ERROR)
        else
          vim.notify(name .. ' toggled', vim.log.levels.INFO)
        end
      end

      -- Terminal instance cache
      local terminal_instances = {}

      -- Explicitly define RAILS_SERVER function
      _G.RAILS_SERVER = function()
        if not terminal_instances.rails_server then
          terminal_instances.rails_server = create_terminal('bundle exec rails s', {
            title = 'Rails Server',
            env = { RAILS_ENV = 'development' },
          })
        end
        safe_toggle(terminal_instances.rails_server, 'rails_server')
      end

      -- Lazy loaded terminals
      local terminals = {
        rails_console = function()
          return create_terminal('bundle exec rails c', {
            title = 'Rails Console',
            env = { RAILS_ENV = 'development' },
          })
        end,
        guard = function()
          return create_terminal('bundle exec guard', {
            title = 'Guard',
          })
        end,
        overmind = function()
          return create_terminal('overmind s', {
            title = 'Overmind',
          })
        end,
        overmind_connect = function()
          return create_terminal('overmind connect web', {
            title = 'Overmind Web',
          })
        end,
      }

      -- Create global toggle functions with lazy initialization
      for name, terminal_creator in pairs(terminals) do
        _G[string.upper(name)] = function()
          if not terminal_instances[name] then
            terminal_instances[name] = terminal_creator()
          end
          safe_toggle(terminal_instances[name], name)
        end
      end

      -- Additional utility functions
      _G.RAILS_RESTART = function()
        if terminal_instances.rails_server then
          terminal_instances.rails_server:shutdown()
          terminal_instances.rails_server = nil
          vim.notify('Rails server stopped', vim.log.levels.INFO)
          vim.defer_fn(function()
            RAILS_SERVER()
          end, 1000)
        else
          RAILS_SERVER()
        end
      end
    end,
    keys = {
      -- Navigation
      { '<leader>rc', '<cmd>Econtroller<CR>', desc = 'Controller' },
      { '<leader>rv', '<cmd>Eview<CR>', desc = 'View' },
      { '<leader>rh', '<cmd>Ehelper<CR>', desc = 'Helper' },
      { '<leader>ra', '<cmd>A<CR>', desc = 'Alternate' },
      { '<leader>rl', '<cmd>Elocale<CR>', desc = 'Locale' },
      { '<leader>ru', '<cmd>Eunittest<CR>', desc = 'Unit test' },
      { '<leader>rm', '<cmd>Emodel<CR>', desc = 'Model' },

      -- Terminals
      { '<leader>rr', '<cmd>lua RAILS_SERVER()<CR>', desc = 'Rails Server' },
      { '<leader>rR', '<cmd>lua RAILS_RESTART()<CR>', desc = 'Restart Rails Server' },
      { '<leader>ri', '<cmd>lua RAILS_CONSOLE()<CR>', desc = 'Rails Console' },
      { '<leader>ro', '<cmd>lua OVERMIND()<CR>', desc = 'Start overmind' },
      { '<leader>rC', '<cmd>lua OVERMIND_CONNECT()<CR>', desc = 'Overmind connect web' },
      { '<leader>rg', '<cmd>lua GUARD()<CR>', desc = 'Run Guard' },
    },
  },
}
