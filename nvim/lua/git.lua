local M = {}

local interval = 5 * 60 * 1000
local status_interval = 10 * 1000
local timeout = 60 * 1000
local operations = {}
local checking = {}
local checking_dirty = {}
local tracking = {}
local branches = {}
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

  if vim.b[buf].dotfiles_git_path == start then
    local root = vim.b[buf].dotfiles_git_root
    return root ~= "" and root or nil
  end

  local root = vim.fs.root(start, { ".git" })
  vim.b[buf].dotfiles_git_path = start
  vim.b[buf].dotfiles_git_root = root or ""
  return root
end

local function redraw_status()
  vim.cmd.redrawstatus()
end

local function parse_head(output)
  for line in (output .. "\n"):gmatch("(.-)\n") do
    local value = line:match("^%*%s*(.-)%s*$")
    if value then
      local branch, status = value:match("^(%S+)%s*(.-)%s*$")
      if status == "[gone]" then return branch, "gone" end

      local ahead = status:match("ahead (%d+)")
      local behind = status:match("behind (%d+)")
      local parts = {}
      if behind then table.insert(parts, "↓" .. behind) end
      if ahead then table.insert(parts, "↑" .. ahead) end
      return branch, table.concat(parts, " ")
    end
  end
  return "", ""
end

local function update_tracking(root)
  if not root then return end
  if checking[root] then return end

  checking[root] = true
  vim.system(
    { "git", "-C", root, "for-each-ref", "--format=%(HEAD) %(refname:short) %(upstream:track)", "refs/heads" },
    {
      env = { LC_ALL = "C" },
      text = true,
      timeout = timeout,
    },
    vim.schedule_wrap(function(result)
      checking[root] = nil

      local branch, status = "", ""
      if result.code == 0 then branch, status = parse_head(result.stdout or "") end
      if branches[root] ~= branch or tracking[root] ~= status then
        branches[root] = branch
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

local function git_path(root, name)
  local result = vim.system(
    { "git", "-C", root, "rev-parse", "--git-path", name },
    { text = true, timeout = timeout }
  ):wait()
  if result.code ~= 0 then return nil end

  local path = vim.trim(result.stdout or "")
  if path == "" then return nil end
  if path:sub(1, 1) ~= "/" then path = root .. "/" .. path end
  return path
end

local function repository_ready(root, action)
  if operations[root] then
    vim.notify("Finish the Git " .. operations[root] .. " operation before " .. action, vim.log.levels.WARN, {
      title = "Git " .. action,
    })
    return false
  end

  local lock_path = git_path(root, "index.lock")
  if lock_path and vim.uv.fs_stat(lock_path) then
    vim.notify("Another Git operation is still running; finish it before " .. action, vim.log.levels.WARN, {
      title = "Git " .. action,
    })
    return false
  end

  return true
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
  if not repository_ready(root, "pull") then return end

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

local function commit_current_repo()
  local root = current_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN)
    return
  end
  if not repository_ready(root, "commit") then return end

  local title = vim.trim(vim.fn.input("Commit title: "))
  if title == "" then return end

  local message = vim.trim(vim.fn.input("Commit message: "))
  if message == "" then return end

  operations[root] = "commit"
  vim.system(
    { "git", "-C", root, "commit", "-m", title, "-m", message },
    { text = true, timeout = timeout },
    vim.schedule_wrap(function(result)
      operations[root] = nil
      if result.code == 0 then
        vim.notify(vim.trim(result.stdout), vim.log.levels.INFO, { title = "Git commit" })
      else
        vim.notify(git_error(result), vim.log.levels.ERROR, { title = "Git commit" })
      end
      update_status(root, true)
      redraw_status()
    end)
  )
end

local function push_current_repo()
  local root = current_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN)
    return
  end
  if not repository_ready(root, "push") then return end

  local branch_result = vim.system(
    { "git", "-C", root, "branch", "--show-current" },
    { text = true, timeout = timeout }
  ):wait()
  local branch = vim.trim(branch_result.stdout or "")
  if branch_result.code ~= 0 or branch == "" then
    vim.notify("Cannot push from a detached HEAD", vim.log.levels.ERROR, { title = "Git push" })
    return
  end

  local upstream_result = vim.system(
    { "git", "-C", root, "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{upstream}" },
    { text = true, timeout = timeout }
  ):wait()
  local set_upstream = upstream_result.code ~= 0 or vim.trim(upstream_result.stdout or "") == ""
  local push_args = { "git", "-C", root, "push" }
  if set_upstream then table.insert(push_args, "--set-upstream") end
  vim.list_extend(push_args, { "origin", "HEAD" })

  local push_command = set_upstream and "git push --set-upstream origin HEAD" or "git push origin HEAD"
  local prompt = ("Push %s to origin?\n\n%s"):format(branch, push_command)
  if set_upstream then
    prompt = ("Push %s to origin and set its upstream?\n\n%s"):format(branch, push_command)
  end

  local choice = vim.fn.confirm(
    prompt,
    "&Push\n&Cancel",
    2
  )
  if choice ~= 1 then return end

  operations[root] = "push"
  vim.system(
    push_args,
    {
      env = { GIT_TERMINAL_PROMPT = "0" },
      text = true,
      timeout = timeout,
    },
    vim.schedule_wrap(function(result)
      operations[root] = nil
      if result.code == 0 then
        local message = vim.trim(result.stderr or "")
        if message == "" then message = "Pushed " .. branch .. " to origin" end
        vim.notify(message, vim.log.levels.INFO, { title = "Git push" })
      else
        vim.notify(git_error(result), vim.log.levels.ERROR, { title = "Git push" })
      end
      update_status(root, true)
      redraw_status()
    end)
  )
end

local function run_git_in_terminal(root, operation, args, options)
  operations[root] = operation
  vim.cmd.tabnew()
  local terminal_buffer = vim.api.nvim_get_current_buf()
  local command = vim.list_extend({ "git", "-C", root }, args)
  local env = vim.tbl_extend("force", { GIT_TERMINAL_PROMPT = "0" }, options.env or {})
  local job = vim.fn.jobstart(command, {
    env = env,
    term = true,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        operations[root] = nil
        if exit_code == 0 then
          if vim.api.nvim_buf_is_valid(terminal_buffer) then
            vim.api.nvim_buf_delete(terminal_buffer, { force = true })
          end
          vim.notify(options.success_message, vim.log.levels.INFO, { title = options.title })
        else
          vim.notify(options.failure_message, vim.log.levels.ERROR, { title = options.title })
        end
        update_status(root, true)
        redraw_status()
      end)
    end,
  })
  if job <= 0 then
    operations[root] = nil
    vim.api.nvim_buf_delete(terminal_buffer, { force = true })
    vim.notify("Unable to open the Git terminal", vim.log.levels.ERROR, { title = options.title })
    return
  end

  vim.cmd.startinsert()
end

local function run_git_command(root, operation, args, options)
  operations[root] = operation
  local command = vim.list_extend({ "git", "-C", root }, args)
  vim.system(
    command,
    {
      env = vim.tbl_extend("force", { GIT_TERMINAL_PROMPT = "0" }, options.env or {}),
      text = true,
      timeout = timeout,
    },
    vim.schedule_wrap(function(result)
      operations[root] = nil
      if result.code == 0 then
        if options.checktime ~= false then vim.cmd.checktime() end
        local message = vim.trim((result.stdout or "") .. "\n" .. (result.stderr or ""))
        vim.notify(message ~= "" and message or options.success_message, vim.log.levels.INFO, {
          title = options.title,
        })
      else
        vim.notify(git_error(result), vim.log.levels.ERROR, { title = options.title })
      end
      update_status(root, true)
      redraw_status()
    end)
  )
end

local function create_branch_current_repo()
  local root = current_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN)
    return
  end
  if not repository_ready(root, "creating a branch") then return end

  local branch = vim.trim(vim.fn.input("New branch name: "))
  if branch == "" then return end

  run_git_command(root, "branch creation", { "switch", "--create", branch }, {
    title = "Git branch",
    success_message = "Created and checked out " .. branch,
  })
end

local function stash_current_repo()
  local root = current_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN)
    return
  end
  if not repository_ready(root, "creating a stash") then return end

  local message = vim.trim(vim.fn.input("Stash message: "))
  if message == "" then return end

  run_git_command(root, "stash", { "stash", "push", "-m", message }, {
    title = "Git stash",
    success_message = "Created stash",
  })
end

local function git_operation(root)
  local function exists(name)
    local path = git_path(root, name)
    return path and vim.uv.fs_stat(path) ~= nil
  end

  if exists("rebase-apply/applying") then
    return { name = "am", continue_args = { "am", "--continue" }, abort_args = { "am", "--abort" } }
  elseif exists("rebase-merge") or exists("rebase-apply") then
    return { name = "rebase", continue_args = { "rebase", "--continue" }, abort_args = { "rebase", "--abort" } }
  elseif exists("MERGE_HEAD") then
    return { name = "merge", continue_args = { "merge", "--continue" }, abort_args = { "merge", "--abort" } }
  elseif exists("CHERRY_PICK_HEAD") then
    return {
      name = "cherry-pick",
      continue_args = { "cherry-pick", "--continue" },
      abort_args = { "cherry-pick", "--abort" },
    }
  elseif exists("REVERT_HEAD") then
    return { name = "revert", continue_args = { "revert", "--continue" }, abort_args = { "revert", "--abort" } }
  end

  return nil
end

local function continue_git_operation()
  local root = current_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN)
    return
  end

  local operation = git_operation(root)
  if not operation then
    vim.notify("No rebase, merge, cherry-pick, revert, or am operation to continue", vim.log.levels.INFO, {
      title = "Git continue",
    })
    return
  end
  if not repository_ready(root, "continuing " .. operation.name) then return end

  run_git_in_terminal(root, operation.name .. " continue", operation.continue_args, {
    env = { GIT_EDITOR = vim.fn.shellescape(vim.v.progpath) },
    title = "Git continue",
    success_message = "Git " .. operation.name .. " completed",
    failure_message = "Git " .. operation.name .. " stopped; see the terminal for details",
  })
end

local function abort_git_operation()
  local root = current_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN)
    return
  end

  local operation = git_operation(root)
  if not operation then
    vim.notify("No rebase, merge, cherry-pick, revert, or am operation to abort", vim.log.levels.INFO, {
      title = "Git abort",
    })
    return
  end
  if not repository_ready(root, "aborting " .. operation.name) then return end

  local choice = vim.fn.confirm(
    ("Abort the current Git %s operation?\n\nThis discards its in-progress changes."):format(operation.name),
    "&Abort\n&Cancel",
    2
  )
  if choice ~= 1 then return end

  run_git_command(root, operation.name .. " abort", operation.abort_args, {
    title = "Git abort",
    success_message = "Aborted Git " .. operation.name,
  })
end

local function amend_current_commit(refresh_date)
  local root = current_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN)
    return
  end
  if not repository_ready(root, "amend") then return end

  local args = refresh_date and { "commit", "--date=now", "--amend" } or { "commit", "--amend" }
  run_git_in_terminal(root, "amend", args, {
    env = { GIT_EDITOR = vim.fn.shellescape(vim.v.progpath) },
    title = "Git amend",
    success_message = refresh_date and "Commit amended with the current author date" or "Commit amended",
    failure_message = "Commit amend stopped; see the terminal for details",
  })
end

local function interactive_rebase_current_repo()
  local root = current_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN)
    return
  end
  if not repository_ready(root, "rebase") then return end

  local input = vim.trim(vim.fn.input("Number of commits to rebase: "))
  if input == "" then return end

  local count = tonumber(input)
  if not count or count < 1 or count % 1 ~= 0 then
    vim.notify("Commit count must be a positive whole number", vim.log.levels.ERROR, { title = "Git rebase" })
    return
  end

  run_git_in_terminal(root, "rebase", { "rebase", "-i", "HEAD~" .. count }, {
    env = { GIT_SEQUENCE_EDITOR = vim.fn.shellescape(vim.v.progpath) },
    title = "Git rebase",
    success_message = "Interactive rebase completed",
    failure_message = "Interactive rebase stopped; see the terminal for details",
  })
end

function M.merge(branch)
  if type(branch) ~= "string" or branch == "" then
    vim.notify("No branch selected", vim.log.levels.WARN, { title = "Git merge" })
    return
  end

  local root = current_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN)
    return
  end
  if not repository_ready(root, "merge") then return end

  local current_result = vim.system(
    { "git", "-C", root, "branch", "--show-current" },
    { text = true, timeout = timeout }
  ):wait()
  local current_branch = vim.trim(current_result.stdout or "")
  if current_result.code ~= 0 or current_branch == "" then
    vim.notify("Cannot merge into a detached HEAD", vim.log.levels.ERROR, { title = "Git merge" })
    return
  end
  if branch == current_branch then
    vim.notify(branch .. " is already the current branch", vim.log.levels.WARN, { title = "Git merge" })
    return
  end

  run_git_in_terminal(root, "merge", { "merge", "--", branch }, {
    env = { GIT_EDITOR = vim.fn.shellescape(vim.v.progpath) },
    title = "Git merge",
    success_message = "Merged " .. branch .. " into " .. current_branch,
    failure_message = "Git merge stopped; see the terminal for details",
  })
end

function M.can_checkout()
  local root = current_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN)
    return false
  end
  return repository_ready(root, "checkout")
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

function M.branch()
  local root = current_root()
  return root and branches[root] or ""
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
  vim.api.nvim_create_user_command("GitCommit", commit_current_repo, {
    desc = "Commit staged changes with a title and message",
  })
  vim.api.nvim_create_user_command("GitPush", push_current_repo, {
    desc = "Push HEAD to origin after confirmation",
  })
  vim.api.nvim_create_user_command("GitBranchNew", create_branch_current_repo, {
    desc = "Create and check out a new branch",
  })
  vim.api.nvim_create_user_command("GitStash", stash_current_repo, {
    desc = "Create a named stash",
  })
  vim.api.nvim_create_user_command("GitContinue", continue_git_operation, {
    desc = "Continue the active Git operation",
  })
  vim.api.nvim_create_user_command("GitAbort", abort_git_operation, {
    desc = "Abort the active Git operation after confirmation",
  })
  vim.api.nvim_create_user_command("GitAmend", function()
    amend_current_commit(false)
  end, { desc = "Amend the current commit in an editor" })
  vim.api.nvim_create_user_command("GitAmendNow", function()
    amend_current_commit(true)
  end, { desc = "Amend the current commit with the current author date" })
  vim.api.nvim_create_user_command("GitRebaseInteractive", interactive_rebase_current_repo, {
    desc = "Interactively rebase a number of recent commits",
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
