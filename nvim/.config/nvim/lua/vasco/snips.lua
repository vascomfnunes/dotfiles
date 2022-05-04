-- SNIPS
--

local status_ok, snips = pcall(require, 'luasnip.loaders.from_vscode')

if not status_ok then
  return
end

snips.lazy_load()
