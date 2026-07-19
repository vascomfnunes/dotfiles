-- Async branch, tracking, and dirty state per repository root, polled for
-- the statusline.
local M = {}
local parsers = require("git.parsers")

local timeout = 60 * 1000
local interval = 10 * 1000
local tracking = {}
local branches = {}
local dirty = {}
local last_check = {}

-- One in-flight check per root; a forced update while one is running queues
-- exactly one rerun so the result is never stale.
local function checker(command, options, apply)
  local running = {}
  local requested = {}

  local function check(root, force)
    if running[root] then
      if force then requested[root] = true end
      return
    end

    running[root] = true
    vim.system(
      command(root),
      vim.tbl_extend("force", { text = true, timeout = timeout }, options),
      vim.schedule_wrap(function(result)
        running[root] = nil
        if requested[root] then
          requested[root] = nil
          check(root, false)
          return
        end
        apply(root, result)
      end)
    )
  end

  return check
end

local update_tracking = checker(
  function(root)
    return { "git", "-C", root, "for-each-ref", "--format=%(HEAD) %(refname:short) %(upstream:track)", "refs/heads" }
  end,
  { env = { LC_ALL = "C" } },
  function(root, result)
    local branch, status = "", ""
    if result.code == 0 then branch, status = parsers.head(result.stdout or "") end
    if branches[root] ~= branch or tracking[root] ~= status then
      branches[root] = branch
      tracking[root] = status
      vim.cmd.redrawstatus()
    end
  end
)

local update_dirty = checker(
  function(root)
    return { "git", "-C", root, "--no-optional-locks", "status", "--porcelain", "--untracked-files=normal" }
  end,
  {},
  function(root, result)
    local is_dirty = result.code == 0 and result.stdout ~= ""
    if dirty[root] ~= is_dirty then
      dirty[root] = is_dirty
      vim.cmd.redrawstatus()
    end
  end
)

function M.update(root, force)
  if not root then return end
  local now = vim.uv.now()
  if not force and last_check[root] and now - last_check[root] < interval then return end
  last_check[root] = now
  update_tracking(root, force)
  update_dirty(root, force)
end

function M.branch(root)
  return branches[root] or ""
end

function M.tracking(root)
  return tracking[root] or ""
end

function M.dirty(root)
  return dirty[root] == true
end

return M
