return {
  'otavioschwanck/tmux-awesome-manager.nvim',
  event = 'VeryLazy',
  config = function()
    require('tmux-awesome-manager').setup {
      session_name = 'Neovim Terminals',
      use_icon = true,
      icon = ' ',
    }
  end,
  keys = {
    {
      '<leader>rg',
      function()
        require('tmux-awesome-manager.src.term').run_wk {
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
        }
      end,
      desc = 'Generate',
    },
  },
}
