local root = assert(arg[1], "dotfiles root is required")
package.path = root .. "/nvim/lua/?.lua;" .. package.path

local project = require("project")
local temporary = vim.fn.tempname()
local repository = temporary .. "/repository"
local nested = repository .. "/app/models"
local loose = temporary .. "/loose"

vim.fn.mkdir(repository .. "/.git", "p")
vim.fn.mkdir(nested, "p")
vim.fn.mkdir(loose, "p")

assert(project.root(nested .. "/user.rb") == repository)
assert(project.root(loose .. "/notes.txt") == loose)
assert(project.root(loose .. "/missing/deep/notes.txt") == loose)

vim.fn.delete(temporary, "rf")
