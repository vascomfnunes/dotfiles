local status_ok, possession = pcall(require, 'possession')

if not status_ok then
  return
end

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
