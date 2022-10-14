-- SNIPS
--

local present, luasnip = pcall(require, 'luasnip')

if not present then
  return
end

luasnip.setup {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
}

local status_ok, snips = pcall(require, 'luasnip.loaders.from_vscode')

if not status_ok then
  return
end

require("luasnip.loaders.from_vscode").lazy_load()

