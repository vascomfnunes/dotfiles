local root = assert(arg[1], "dotfiles root is required")
package.path = root .. "/nvim/lua/?.lua;" .. package.path

local cache_dir = vim.fn.tempname()
vim.fn.mkdir(cache_dir, "p")

local orig_env = {
  HERDR_ENV = vim.env.HERDR_ENV,
  HERDR_PANE_ID = vim.env.HERDR_PANE_ID,
  XDG_CACHE_HOME = vim.env.XDG_CACHE_HOME,
}
vim.env.HERDR_ENV = "1"
vim.env.HERDR_PANE_ID = "w1:p42"
vim.env.XDG_CACHE_HOME = cache_dir

local calls = {}
local orig_system = vim.system
vim.system = function(cmd)
  table.insert(calls, cmd)
end

local herdr = require("herdr")
herdr.setup()

-- Marker file contains PID and servername, and tracks suspend/resume/exit.
local marker = herdr.marker_path()
assert(marker == cache_dir .. "/herdr/nvim-panes/w1:p42", "unexpected marker path")
local lines = vim.fn.readfile(marker)
assert(lines[1] == tostring(vim.fn.getpid()), "marker did not record Neovim PID")
assert(lines[2] == (vim.v.servername or ""), "marker did not record servername")

vim.api.nvim_exec_autocmds("VimSuspend", {})
assert(vim.uv.fs_stat(marker) == nil, "marker was not removed on VimSuspend")

vim.api.nvim_exec_autocmds("VimResume", {})
assert(vim.uv.fs_stat(marker) ~= nil, "marker was not restored on VimResume")

-- Single window: navigation and resize delegate to Herdr.
herdr.move("left")
assert(vim.deep_equal(calls[#calls], {
  "herdr", "pane", "focus", "--current", "--direction", "left",
}), "edge move did not delegate to herdr")

herdr.resize("right")
assert(vim.deep_equal(calls[#calls], {
  "herdr", "pane", "resize", "--current", "--direction", "right", "--amount", "0.05",
}), "single-window resize did not delegate to herdr")

-- Split creation and in-editor navigation/resize stay inside Neovim until an edge.
local calls_before = #calls
assert(herdr.split("right") == 1, "vertical split did not succeed")
assert(#vim.api.nvim_tabpage_list_wins(0) == 2, "vsplit did not create a second window")

local win_after_split = vim.api.nvim_get_current_win()
herdr.move("right")
if vim.api.nvim_get_current_win() == win_after_split then
  -- splitright was off in -u NONE; move left instead to verify internal move.
  calls_before = #calls
  herdr.move("left")
end
assert(#calls == calls_before, "internal split navigation should not call herdr")

calls_before = #calls
herdr.resize("right", 2)
assert(#calls == calls_before, "horizontal resize with vertical split should stay in Neovim")

-- Vertical resize still delegates to Herdr because there is no horizontal split.
herdr.resize("down")
assert(vim.deep_equal(calls[#calls], {
  "herdr", "pane", "resize", "--current", "--direction", "down", "--amount", "0.05",
}), "resize along unsplit axis did not delegate to herdr")

assert(herdr.split("down") == 1, "horizontal split did not succeed")
assert(#vim.api.nvim_tabpage_list_wins(0) == 3, "split did not create a third window")

-- Clean up marker on VimLeavePre.
vim.api.nvim_exec_autocmds("VimLeavePre", {})
assert(vim.uv.fs_stat(marker) == nil, "marker was not removed on VimLeavePre")

vim.system = orig_system
vim.env.HERDR_ENV = orig_env.HERDR_ENV
vim.env.HERDR_PANE_ID = orig_env.HERDR_PANE_ID
vim.env.XDG_CACHE_HOME = orig_env.XDG_CACHE_HOME
vim.fn.delete(cache_dir, "rf")
