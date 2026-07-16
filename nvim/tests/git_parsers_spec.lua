local root = assert(arg[1], "dotfiles root is required")
package.path = root .. "/nvim/lua/?.lua;" .. root .. "/nvim/lua/?/init.lua;" .. package.path

local parsers = require("git.parsers")

local function eq(actual, expected)
  assert(actual == expected, ("expected %q, got %q"):format(expected, actual))
end

local branch, status = parsers.head("  feature\n* main [ahead 2, behind 3]\n")
eq(branch, "main")
eq(status, "↓3 ↑2")

branch, status = parsers.head("* topic [gone]\n")
eq(branch, "topic")
eq(status, "gone")

branch, status = parsers.head("")
eq(branch, "")
eq(status, "")

eq(parsers.selected_branch({ "* main" }), "main")
eq(parsers.selected_branch({ "  remotes/origin/topic" }), "remotes/origin/topic")
eq(parsers.selected_branch({ "\27[31m+ worktree-branch\27[0m" }), "worktree-branch")
eq(parsers.selected_branch({}), nil)

local detect_operation = require("git.operation").detect
local function detect(...)
  local present = {}
  for _, name in ipairs({ ... }) do present[name] = true end
  return detect_operation(function(name) return present[name] == true end)
end

eq(detect("MERGE_HEAD").name, "merge")
eq(detect("CHERRY_PICK_HEAD").name, "cherry-pick")
eq(detect("REVERT_HEAD").name, "revert")
eq(detect("rebase-merge").name, "rebase")
eq(detect("rebase-apply", "rebase-apply/applying").name, "am")
eq(detect(), nil)
