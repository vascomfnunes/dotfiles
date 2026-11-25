local root = assert(arg[1], "dotfiles root is required")
package.path = root .. "/nvim/lua/?.lua;" .. package.path

local tags = require("tags")
local temporary = vim.fn.tempname() .. ", tag path with space"
local repository = temporary .. "/repository"
local worktree = temporary .. "/worktree"

local function git(cwd, ...)
  local command = { "git", "-C", cwd }
  vim.list_extend(command, { ... })
  local result = vim.system(command, { text = true }):wait()
  assert(result.code == 0, result.stderr)
  return vim.trim(result.stdout or "")
end

vim.fn.mkdir(repository, "p")
git(repository, "init", "--initial-branch=main")
git(repository, "config", "user.email", "nvim-test@example.invalid")
git(repository, "config", "user.name", "Neovim Test")
git(repository, "config", "commit.gpgsign", "false")
vim.fn.writefile({ "initial" }, repository .. "/README")
git(repository, "add", "README")
git(repository, "commit", "--no-verify", "-m", "initial")
git(repository, "worktree", "add", "-b", "linked", worktree)

local expected = git(worktree, "rev-parse", "--path-format=absolute", "--git-path", "tags")
assert(tags.path(worktree) == expected)
assert(tags.path(worktree) ~= worktree .. "/.git/tags")

local original = vim.bo.tags
vim.fn.writefile({ "Sample\tREADME\t1" }, expected)
tags.with_file(0, expected, function()
  local matches = vim.fn.taglist("^Sample$")
  assert(#matches == 1)
  assert(matches[1].name == "Sample")
end)
assert(vim.bo.tags == original)

local ok = pcall(tags.with_file, 0, expected, function() error("expected failure") end)
assert(not ok)
assert(vim.bo.tags == original)

vim.fn.writefile({ 'source "https://rubygems.org"' }, repository .. "/Gemfile")
vim.cmd.edit(vim.fn.fnameescape(repository .. "/README"))
tags.setup()

local spawned = 0
local pending_callback
local notices = {}
local orig_system = vim.system
local orig_notify = vim.notify
vim.notify = function(msg) notices[#notices + 1] = msg end
vim.system = function(cmd, opts, on_exit)
  if type(on_exit) == "function" then
    spawned = spawned + 1
    pending_callback = on_exit
    return {}
  end
  return orig_system(cmd, opts)
end

vim.cmd("GemTags")
vim.cmd("GemTags")
assert(spawned == 1, "concurrent :GemTags spawned a second job")
assert(vim.g.gemtags_running == true)
assert(notices[#notices] == "GemTags is already running")
pending_callback({ code = 1, stderr = "stop" })
assert(vim.wait(1000, function() return vim.g.gemtags_running == nil end, 10))
vim.system = orig_system
vim.notify = orig_notify

vim.fn.delete(temporary, "rf")
