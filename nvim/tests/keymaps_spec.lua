local root = assert(arg[1], "dotfiles root is required")
package.path = root .. "/nvim/lua/?.lua;" .. package.path

local picker_win
-- Loader no-ops: keymaps must work without installing or loading plugins.
package.loaded["lazyload"] = setmetatable({}, {
  __index = function() return function() end end,
})
package.loaded["fzf-lua"] = {
  lsp_definitions = function()
    picker_win = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
      relative = "editor",
      row = 0,
      col = 0,
      width = 20,
      height = 5,
      style = "minimal",
    })
  end,
  git_commits = function() end,
}

local get_clients = vim.lsp.get_clients
local buf_request_all = vim.lsp.buf_request_all
vim.lsp.get_clients = function()
  return { { offset_encoding = "utf-16" } }
end
vim.lsp.buf_request_all = function(_, _, _, callback)
  callback({
    css_classes = {
      result = {
        { uri = "file:///first.css" },
        { uri = "file:///second.css" },
      },
    },
  })
end

local keymaps = require("keymaps")

local gd
for _, mapping in ipairs(vim.api.nvim_get_keymap("n")) do
  if mapping.lhs == "gd" then gd = mapping.callback end
end
assert(type(gd) == "function", "gd mapping was not found")

local source_win = vim.api.nvim_get_current_win()
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "button" })
gd()
vim.lsp.get_clients = get_clients
vim.lsp.buf_request_all = buf_request_all

assert(vim.api.nvim_win_is_valid(picker_win), "definition picker did not open")
assert(vim.api.nvim_get_current_win() == picker_win, "definition picker did not retain focus")
assert(vim.api.nvim_get_current_win() ~= source_win)

local checkout
for _, mapping in ipairs(vim.api.nvim_get_keymap("n")) do
  if mapping.desc == "Checkout branch" then checkout = mapping.callback end
end
assert(type(checkout) == "function", "checkout mapping was not found")

local picker_opts
package.loaded["fzf-lua"].git_branches = function(opts) picker_opts = opts end
local calls = {}
package.loaded["fzf-lua.actions"] = {
  git_switch = function() table.insert(calls, "switch") end,
}
local git = require("git")
git.can_checkout = function() return true end
git.refresh = function() table.insert(calls, "refresh") end

checkout()
assert(type(picker_opts.actions.enter) == "function", "checkout action was not configured")
picker_opts.actions.enter({ "main" }, {})
assert(vim.deep_equal(calls, { "switch", "refresh" }), "status did not refresh after branch checkout")

local cherry_pick
local stage_all
local unstage_all
for _, mapping in ipairs(vim.api.nvim_get_keymap("n")) do
  if mapping.desc == "Cherry-pick commit" then cherry_pick = mapping.callback end
  if mapping.desc == "Stage all changes" then stage_all = mapping end
  if mapping.desc == "Unstage all changes" then unstage_all = mapping end
end
assert(type(cherry_pick) == "function", "cherry-pick mapping was not found")
assert(stage_all and stage_all.lhs == " gS", "stage-all mapping was not found")
assert(unstage_all and unstage_all.lhs == " gU", "unstage-all mapping was not found")

local branch_opts
local commit_opts
local cherry_picked
package.loaded["fzf-lua"].git_branches = function(opts) branch_opts = opts end
package.loaded["fzf-lua"].git_commits = function(opts) commit_opts = opts end
git.cherry_pick = function(commit) cherry_picked = commit end

cherry_pick()
assert(branch_opts.remotes == "all", "cherry-pick branch picker did not include remote branches")
branch_opts.actions.enter({ "  feature" })
assert(commit_opts.cmd:match("feature"), "commit picker did not use the selected branch")
assert(commit_opts.cmd:match("%-%-not HEAD"), "commit picker did not exclude commits already in HEAD")
commit_opts.actions.enter({ "abc1234 two days ago A useful change <Author>" })
assert(cherry_picked == "abc1234", "selected commit was not cherry-picked")

local function mapping(mode, desc)
  for _, item in ipairs(vim.api.nvim_get_keymap(mode)) do
    if item.desc == desc then return item end
  end
end

local ai_commit = mapping("n", "Commit with generated message")
assert(ai_commit and ai_commit.lhs == " gG", "generated-message commit mapping was not found")

local git_log = mapping("n", "Commit log")
assert(git_log and git_log.lhs == " gl", "git log mapping was not found")
local log_opened = false
local log_opts
package.loaded["fzf-lua"].git_commits = function(opts)
  log_opened = true
  log_opts = opts
end
git_log.callback()
assert(log_opened, "git log mapping did not open the commit picker")
assert(type(log_opts.actions.enter) == "function", "commit log enter action was not configured")
assert(type(log_opts.actions["ctrl-o"]) == "function", "commit checkout action was not configured")

assert(keymaps.location("/tmp/example.lua", 3) == "/tmp/example.lua:3", "line reference format is wrong")
assert(keymaps.location("/tmp/example.lua", 3, 7) == "/tmp/example.lua:3-7", "range reference format is wrong")
assert(keymaps.location("/tmp/example.lua", 3, 3) == "/tmp/example.lua:3", "single-line range was not collapsed")

local copied
local setreg = vim.fn.setreg
vim.fn.setreg = function(register, text)
  assert(register == "+", "reference was not copied to the clipboard register")
  copied = text
end

local path = vim.fn.tempname() .. ".lua"
vim.fn.writefile({ "one", "two", "three" }, path)
vim.cmd.edit(vim.fn.fnameescape(path))
local absolute = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")

local copy_line = mapping("n", "Copy line reference")
assert(copy_line and copy_line.lhs == " al" and copy_line.callback, "copy-line mapping was not found")
vim.api.nvim_win_set_cursor(0, { 2, 0 })
copy_line.callback()
assert(copied == absolute .. ":2", "current line reference was not copied")

local copy_file = mapping("n", "Copy file path")
assert(copy_file and copy_file.lhs == " af" and copy_file.callback, "copy-file-path mapping was not found")
copy_file.callback()
assert(copied == absolute, "absolute file path was not copied")

local copy_range = mapping("x", "Copy line range reference")
assert(copy_range and copy_range.lhs == " al" and copy_range.callback, "copy-range mapping was not found")

vim.api.nvim_win_set_cursor(0, { 1, 0 })
vim.cmd("normal! Vj")
copy_range.callback()
assert(copied == absolute .. ":1-2", "visual line range reference was not copied")

vim.api.nvim_win_set_cursor(0, { 1, 0 })
vim.cmd("normal! vjj")
copy_range.callback()
assert(copied == absolute .. ":1-2", "charwise selection included the line after the selection")

vim.fn.setreg = setreg
