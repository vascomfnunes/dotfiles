local cmd = vim.cmd
local fn = vim.fn

local M = {}

-- check if a variable is not empty nor nil
M.isNotEmpty = function(s)
  return s ~= nil and s ~= ''
end

-- toggle quickfixlist
M.toggle_qf = function()
  local windows = fn.getwininfo()
  local qf_exists = false
  for _, win in pairs(windows) do
    if win['quickfix'] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    cmd 'cclose'
    return
  end
  if M.isNotEmpty(fn.getqflist()) then
    cmd 'copen'
  end
end

function M.list_registered_providers_names(filetype)
  local s = require 'null-ls.sources'
  local available_sources = s.get_available(filetype)
  local registered = {}
  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end
  return registered
end

function M.list_registered_formatters(filetype)
  local registered_providers = M.list_registered_providers_names(filetype)
  local method = require('null-ls').methods.FORMATTING
  return registered_providers[method] or {}
end

function M.list_registered_linters(filetype)
  local registered_providers = M.list_registered_providers_names(filetype)
  local method = require('null-ls').methods.DIAGNOSTICS
  return registered_providers[method] or {}
end

return M
