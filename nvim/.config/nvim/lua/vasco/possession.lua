local status_ok, possession = pcall(require, 'possession')

if not status_ok then
  return
end

possession.setup {
  commands = {
    save = 'SSave',
    load = 'SLoad',
    delete = 'SDelete',
    list = 'SList',
  },
}
