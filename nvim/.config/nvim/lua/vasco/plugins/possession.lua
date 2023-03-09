return {
  'jedrzejboczar/possession.nvim',
  cmd = {
    'SessionSave',
    'SessionLoad',
    'SessionClose',
    'SessionDelete',
    'SessionShow',
    'SessionList',
    'SessionMigrate',
  },
  opts = {
    commands = {
      save = 'SessionSave',
      load = 'SessionLoad',
      close = 'SessionClose',
      delete = 'SessionDelete',
      show = 'SessionShow',
      list = 'SessionList',
      migrate = 'SessionMigrate',
    },
  },
}
