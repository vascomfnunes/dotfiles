local M = {}

local interval = 5 * 60 * 1000
local status_interval = 10 * 1000
local timeout = 60 * 1000
local operations = {}
local checking = {}
local checking_dirty = {}
local tracking = {}
local dirty = {}
local fetch_failed = {}
local last_attempt = {}
local last_status_check = {}
local focused = true
local timer

local function current_root()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) or ""
  local start = path ~= "" and path or vim.fn.getcwd()

  if vim.b[buf].git_fetch_path == start then
    local root = vim.b[buf].git_fetch_root
    return root ~= "" and root or nil
  end

  local root = vim.fs.root(start, { ".git" })
  vim.b[buf].git_fetch_path = start
  vim.b[buf].git_fetch_root = root or ""
  return root
end

local function redraw_status()
  local lualine = package.loaded.lualine
  if lualine then
    lualine.refresh({ place = { "statusline" } })
  else
    vim.cmd.redrawstatus()
  end
end

local function parse_tracking(output)
  for line in (output .. "\n"):gmatch("(.-)\n") do
    local value = line:match("^%*%s*(.-)%s*$")
    if value then
      if value == "[gone]" then return "gone" end

      local ahead = value:match("ahead (%d+)")
      local behind = value:match("behind (%d+)")
      local parts = {}
      if behind then table.insert(parts, "↓" .. behind) end
      if ahead then table.insert(parts, "↑" .. ahead) end
      return table.concat(parts, " ")
    end
  end
  return ""
end

local function update_tracking(root)
  if not root then return end
  if checking[root] then return end

  checking[root] = true
  vim.system(
    { "git", "-C", root, "for-each-ref", "--format=%(HEAD) %(upstream:track)", "refs/heads" },
    {
      env = { LC_ALL = "C" },
      text = true,
      timeout = timeout,
    },
    vim.schedule_wrap(function(result)
      checking[root] = nil

      local status = result.code == 0 and parse_tracking(result.stdout or "") or ""
      if tracking[root] ~= status then
        tracking[root] = status
        redraw_status()
      end
    end)
  )
end

local function update_dirty(root)
  if not root then return end
  if checking_dirty[root] then return end

  checking_dirty[root] = true
  vim.system(
    { "git", "-C", root, "status", "--porcelain", "--untracked-files=normal" },
    { text = true, timeout = timeout },
    vim.schedule_wrap(function(result)
      checking_dirty[root] = nil

      local is_dirty = result.code == 0 and result.stdout ~= ""
      if dirty[root] ~= is_dirty then
        dirty[root] = is_dirty
        redraw_status()
      end
    end)
  )
end

local function update_status(root, force)
  if not root then return end
  local now = vim.uv.now()
  if not force and last_status_check[root] and now - last_status_check[root] < status_interval then
    return
  end
  last_status_check[root] = now
  update_tracking(root)
  update_dirty(root)
end

local function git_error(result)
  local message = vim.trim(result.stderr or "")
  return message ~= "" and message or "Git command failed"
end

local function fetch(root, notify)
  if operations[root] then
    if notify then vim.notify("Git " .. operations[root] .. " already in progress", vim.log.levels.INFO) end
    return
  end

  operations[root] = "fetch"
  last_attempt[root] = vim.uv.now()
  vim.system(
    { "git", "-C", root, "fetch", "--quiet", "--prune", "--no-write-fetch-head" },
    {
      env = { GIT_TERMINAL_PROMPT = "0" },
      text = true,
      timeout = timeout,
    },
    vim.schedule_wrap(function(result)
      operations[root] = nil
      fetch_failed[root] = result.code ~= 0
      update_status(root, true)
      redraw_status()

      if notify then
        if result.code == 0 then
          vim.notify("Fetched remote updates", vim.log.levels.INFO)
        else
          vim.notify(git_error(result), vim.log.levels.ERROR, { title = "Git fetch" })
        end
      end
    end)
  )
end

local function fetch_current_repo(force, notify)
  local root = current_root()
  if not root then
    if notify then vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN) end
    return
  end

  local last = last_attempt[root]
  if force or not last or vim.uv.now() - last >= interval then
    fetch(root, notify)
  elseif notify then
    vim.notify("Remote updates were fetched recently", vim.log.levels.INFO)
  end
end

local function pull_current_repo()
  local root = current_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN)
    return
  end
  if operations[root] then
    vim.notify("Git " .. operations[root] .. " already in progress", vim.log.levels.INFO)
    return
  end

  operations[root] = "pull"
  last_attempt[root] = vim.uv.now()
  vim.system(
    { "git", "-C", root, "pull", "--ff-only" },
    {
      env = { GIT_TERMINAL_PROMPT = "0" },
      text = true,
      timeout = timeout,
    },
    vim.schedule_wrap(function(result)
      operations[root] = nil
      if result.code == 0 then
        fetch_failed[root] = false
        vim.cmd.checktime()
        vim.notify(vim.trim(result.stdout), vim.log.levels.INFO, { title = "Git pull" })
      else
        vim.notify(git_error(result), vim.log.levels.ERROR, { title = "Git pull" })
      end
      update_status(root, true)
      redraw_status()
    end)
  )
end

function M.status()
  local root = current_root()
  if not root then return "" end

  local parts = {}
  if tracking[root] and tracking[root] ~= "" then table.insert(parts, tracking[root]) end
  if dirty[root] or vim.bo.modified then table.insert(parts, "●") end
  if fetch_failed[root] then table.insert(parts, "!") end
  return table.concat(parts, " ")
end

function M.setup()
  if timer then return end

  timer = assert(vim.uv.new_timer())
  timer:start(interval, interval, vim.schedule_wrap(function()
    if focused then fetch_current_repo(true, false) end
  end))

  vim.api.nvim_create_autocmd("FocusLost", {
    callback = function()
      focused = false
    end,
  })
  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function()
      focused = true
      update_status(current_root(), true)
    end,
  })
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      if vim.bo.buftype ~= "" then return end
      update_status(current_root(), false)
    end,
  })
  vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function()
      update_status(current_root(), true)
    end,
  })
  vim.api.nvim_create_autocmd("BufModifiedSet", {
    callback = redraw_status,
  })

  vim.api.nvim_create_user_command("GitFetch", function()
    fetch_current_repo(true, true)
  end, { desc = "Fetch remote updates now" })
  vim.api.nvim_create_user_command("GitPull", pull_current_repo, {
    desc = "Fast-forward the current branch",
  })

  vim.defer_fn(function()
    update_status(current_root(), false)
  end, 1000)

  vim.api.nvim_create_autocmd("VimLeavePre", {
    once = true,
    callback = function()
      timer:stop()
      timer:close()
    end,
  })
end

return M
