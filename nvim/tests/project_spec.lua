local root = assert(arg[1], "dotfiles root is required")
package.path = root .. "/nvim/lua/?.lua;" .. package.path

local project = require("project")
local temporary = vim.fn.tempname()
vim.fn.mkdir(temporary, "p")
temporary = assert(vim.uv.fs_realpath(temporary))
local repository = temporary .. "/repository"
local nested = repository .. "/app/models"
local loose = temporary .. "/loose"

vim.fn.mkdir(repository .. "/.git", "p")
vim.fn.mkdir(nested, "p")
vim.fn.mkdir(loose, "p")

assert(project.root(nested .. "/user.rb") == repository)
assert(project.root(loose .. "/notes.txt") == loose)
assert(project.root(loose .. "/missing/deep/notes.txt") == loose)

project.setup()
vim.cmd.edit(vim.fn.fnameescape(nested .. "/user.rb"))
assert(vim.fn.getcwd() == repository)
assert(project.select(loose))
assert(vim.fn.getcwd() == loose)
assert(vim.fn.getcwd(-1, -1) == loose)
vim.cmd.edit(vim.fn.fnameescape(nested .. "/other.rb"))
assert(vim.fn.getcwd() == loose)
assert(not project.select(temporary .. "/missing"))
assert(vim.fn.getcwd() == loose)
local closed = false
package.loaded["mini.files"] = {
  get_fs_entry = function() return { path = loose, fs_type = "directory" } end,
  close = function() closed = true end,
}
local explorer = vim.api.nvim_create_buf(false, true)
vim.api.nvim_exec_autocmds("User", { pattern = "MiniFilesBufferCreate", data = { buf_id = explorer } })
local mapping = vim.fn.maparg("gp", "n", false, true)
vim.api.nvim_buf_call(explorer, function() mapping = vim.fn.maparg("gp", "n", false, true) end)
assert(mapping.callback)
mapping.callback()
assert(closed)
assert(vim.fn.getcwd(-1, -1) == loose)

vim.fn.delete(temporary, "rf")
