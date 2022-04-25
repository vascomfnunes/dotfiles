local M = {
  'otavioschwanck/tmux-awesome-manager.nvim',
}

M.ft = { 'ruby' }

function M.config()
  require('tmux-awesome-manager').setup {
    -- default_size = '30%', -- on panes, the default size
  }
end

return M
