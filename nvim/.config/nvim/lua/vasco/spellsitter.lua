local status_ok, spellsitter = pcall(require, 'spellsitter')

if not status_ok then
  return
end

spellsitter.setup {
  enable = true,
}
