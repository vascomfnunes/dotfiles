local utils = require 'utils'

local M = {}
local augroups = {}

local function set_groups()
  augroups = {
    vim = {
      {"TextYankPost", "*", "silent! lua vim.highlight.on_yank()"},
      {"BufWritePre", "*", ":call TrimWhitespace()"}
    },
    emmet = {{"FileType", "html,css,scss,eruby", "EmmetInstall"}},
    fugitive = {{"BufReadPost", "fugitive://*", "set bufhidden=delete"}},
    packer = {{"BufWritePost", "plugins.lua", "PackerCompile"}}
  }
end

function M.init()
  set_groups()
  utils.nvim_create_augroups(augroups)
end

return M
