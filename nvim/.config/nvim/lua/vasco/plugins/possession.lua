local M = {
  'jedrzejboczar/possession.nvim',
}

M.cmd = {
  'SessionSave',
  'SessionLoad',
  'SessionClose',
  'SessionDelete',
  'SessionShow',
  'SessionList',
  'SessionMigrate',
}

function M.config()
  local possession = require 'possession'

  possession.setup {
    commands = {
      save = 'SessionSave',
      load = 'SessionLoad',
      close = 'SessionClose',
      delete = 'SessionDelete',
      show = 'SessionShow',
      list = 'SessionList',
      migrate = 'SessionMigrate',
    },
  }
end

return M
