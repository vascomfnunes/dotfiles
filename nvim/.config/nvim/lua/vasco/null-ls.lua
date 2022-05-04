-- NULL-LS
--

local status_ok, null_ls = pcall(require, 'null-ls')

if not status_ok then
  return
end

local formatter_install = require 'format-installer'

local sources = {}

for _, formatter in ipairs(formatter_install.get_installed_formatters()) do
  local config = { command = formatter.cmd }
  table.insert(sources, null_ls.builtins.formatting[formatter.name].with(config))
end

null_ls.setup { sources = sources }
