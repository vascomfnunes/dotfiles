return {
  'otavioschwanck/tmux-awesome-manager.nvim',
  event = 'VeryLazy',
  config = function()
    require('tmux-awesome-manager').setup {
      session_name = 'Neovim Terminals',
      use_icon = true,
      icon = ' ',
    }

    local tmux_term = require 'tmux-awesome-manager.src.term'
    local wk = require 'which-key'

    wk.register({
      r = {
        -- name = 'Rails',
        R = tmux_term.run_wk {
          cmd = 'bundle exec rails s',
          name = 'Rails Server',
          visit_first_call = false,
          open_as = 'separated_session',
          session_name = 'My Terms',
        },
        r = tmux_term.run_wk { cmd = 'bundle exec rails c', name = 'Rails Console', open_as = 'window' },
        b = tmux_term.run_wk {
          cmd = 'bundle install',
          name = 'Bundle Install',
          open_as = 'pane',
          close_on_timer = 2,
          visit_first_call = false,
          focus_when_call = false,
        },
        t = tmux_term.run_wk {
          cmd = 'bundle exec rails test',
          name = 'Run all minitests',
          open_as = 'pane',
          close_on_timer = 2,
          visit_first_call = false,
          focus_when_call = false,
        },
        g = tmux_term.run_wk {
          cmd = 'bundle exec rails generate %1',
          name = 'Rails Generate',
          questions = {
            {
              question = 'Rails generate: ',
              required = true,
              open_as = 'pane',
              close_on_timer = 4,
              visit_first_call = false,
              focus_when_call = false,
            },
          },
        },
        d = tmux_term.run_wk {
          cmd = 'bundle exec rails destroy %1',
          name = 'Rails Destroy',
          questions = {
            {
              question = 'Rails destroy: ',
              required = true,
              open_as = 'pane',
              close_on_timer = 4,
              visit_first_call = false,
              focus_when_call = false,
            },
          },
        },
      },
    }, { prefix = '<leader>', silent = true })
  end,
}
