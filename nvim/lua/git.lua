local M = {}
local detect_git_operation = require("git.operation").detect
local status = require("git.status")

local interval = 5 * 60 * 1000
local timeout = 60 * 1000
local operations = {}
local fetch_failed = {}
local last_attempt = {}
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

local function require_root()
  local root = current_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.WARN)
  end
  return root
end

local function redraw_status()
  vim.cmd.redrawstatus()
end

local function git_error(result)
  local message = vim.trim(result.stderr or "")
  return message ~= "" and message or "Git command failed"
end

-- Current branch name, or nil on detached HEAD.
local function current_branch(root)
  local result = vim.system(
    { "git", "-C", root, "branch", "--show-current" },
    { text = true, timeout = timeout }
  ):wait()
  local branch = vim.trim(result.stdout or "")
  return (result.code == 0 and branch ~= "") and branch or nil
end

local function git_directory(root)
  local result = vim.system(
    { "git", "-C", root, "rev-parse", "--absolute-git-dir" },
    { text = true, timeout = timeout }
  ):wait()
  if result.code ~= 0 then return nil end

  local path = vim.trim(result.stdout or "")
  return path ~= "" and path or nil
end

local function git_operation(directory)
  if not directory then return nil end

  return detect_git_operation(function(name)
    return vim.uv.fs_stat(vim.fs.joinpath(directory, name)) ~= nil
  end)
end

local function repository_ready(root, action, allow_in_progress, directory)
  if operations[root] then
    vim.notify("Finish the Git " .. operations[root] .. " operation before " .. action, vim.log.levels.WARN, {
      title = "Git " .. action,
    })
    return false
  end

  directory = directory or git_directory(root)
  local lock_path = directory and vim.fs.joinpath(directory, "index.lock")
  if lock_path and vim.uv.fs_stat(lock_path) then
    vim.notify("Another Git operation is still running; finish it before " .. action, vim.log.levels.WARN, {
      title = "Git " .. action,
    })
    return false
  end

  local in_progress = git_operation(directory)
  if in_progress and not allow_in_progress then
    vim.notify("Finish or abort the Git " .. in_progress.name .. " before " .. action, vim.log.levels.WARN, {
      title = "Git " .. action,
    })
    return false
  end

  return true
end

-- Root of the current repository, only when no conflicting operation is
-- running; nil (after notifying) otherwise.
local function ready_root(action, allow_in_progress, directory)
  local root = require_root()
  if root and repository_ready(root, action, allow_in_progress, directory) then return root end
  return nil
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
      status.update(root, true)
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
  local root = notify and require_root() or current_root()
  if not root then return end

  local last = last_attempt[root]
  if force or not last or vim.uv.now() - last >= interval then
    fetch(root, notify)
  elseif notify then
    vim.notify("Remote updates were fetched recently", vim.log.levels.INFO)
  end
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
          vim.cmd.checktime()
          if vim.api.nvim_buf_is_valid(terminal_buffer) then
            vim.api.nvim_buf_delete(terminal_buffer, { force = true })
          end
          vim.notify(options.success_message, vim.log.levels.INFO, { title = options.title })
        else
          vim.notify(options.failure_message, vim.log.levels.ERROR, { title = options.title })
        end
        status.update(root, true)
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
        if options.on_success then options.on_success() end
        local message = vim.trim((result.stdout or "") .. "\n" .. (result.stderr or ""))
        vim.notify(message ~= "" and message or options.success_message, vim.log.levels.INFO, {
          title = options.title,
        })
      else
        vim.notify(git_error(result), vim.log.levels.ERROR, { title = options.title })
      end
      status.update(root, true)
      redraw_status()
    end)
  )
end

local function pull_current_repo()
  local root = ready_root("pull")
  if not root then return end

  last_attempt[root] = vim.uv.now()
  run_git_command(root, "pull", { "pull", "--ff-only" }, {
    title = "Git pull",
    success_message = "Already up to date",
    on_success = function() fetch_failed[root] = false end,
  })
end

local function commit_current_repo()
  local root = ready_root("commit")
  if not root then return end

  local title = vim.trim(vim.fn.input("Commit title: "))
  if title == "" then return end

  -- An empty message produces a title-only commit.
  local message = vim.trim(vim.fn.input("Commit message: "))

  local args = { "commit", "-m", title }
  if message ~= "" then vim.list_extend(args, { "-m", message }) end

  run_git_command(root, "commit", args, {
    title = "Git commit",
    success_message = "Committed staged changes",
    checktime = false,
  })
end

local function push_current_repo()
  local root = ready_root("push")
  if not root then return end

  local branch = current_branch(root)
  if not branch then
    vim.notify("Cannot push from a detached HEAD", vim.log.levels.ERROR, { title = "Git push" })
    return
  end

  local upstream_result = vim.system(
    { "git", "-C", root, "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{upstream}" },
    { text = true, timeout = timeout }
  ):wait()
  local set_upstream = upstream_result.code ~= 0 or vim.trim(upstream_result.stdout or "") == ""
  local push_args = { "push" }
  if set_upstream then table.insert(push_args, "--set-upstream") end
  vim.list_extend(push_args, { "origin", "HEAD" })

  local prompt = set_upstream
    and ("Push %s to origin and set its upstream?\n\ngit push --set-upstream origin HEAD"):format(branch)
    or ("Push %s to origin?\n\ngit push origin HEAD"):format(branch)
  if vim.fn.confirm(prompt, "&Push\n&Cancel", 2) ~= 1 then return end

  run_git_command(root, "push", push_args, {
    title = "Git push",
    success_message = "Pushed " .. branch .. " to origin",
    checktime = false,
  })
end

local function create_branch_current_repo()
  local root = ready_root("creating a branch")
  if not root then return end

  local branch = vim.trim(vim.fn.input("New branch name: "))
  if branch == "" then return end

  run_git_command(root, "branch creation", { "switch", "--create", branch }, {
    title = "Git branch",
    success_message = "Created and checked out " .. branch,
  })
end

local function stash_current_repo()
  local root = ready_root("creating a stash")
  if not root then return end

  local message = vim.trim(vim.fn.input("Stash message: "))
  if message == "" then return end

  run_git_command(root, "stash", { "stash", "push", "-m", message }, {
    title = "Git stash",
    success_message = "Created stash",
  })
end

local function stage_all_current_repo()
  local root = ready_root("staging all changes", true)
  if not root then return end

  run_git_command(root, "stage all", { "add", "--all" }, {
    title = "Git stage",
    success_message = "Staged all changes",
    checktime = false,
  })
end

local function unstage_all_current_repo()
  local root = ready_root("unstaging all changes", true)
  if not root then return end

  run_git_command(root, "unstage all", { "reset", "--mixed", "--quiet" }, {
    title = "Git unstage",
    success_message = "Unstaged all changes",
    checktime = false,
  })
end

-- Root and detected in-progress operation for :GitContinue/:GitAbort, or nil
-- (after notifying) when there is nothing to act on.
local function active_operation(verb, gerund)
  local root = require_root()
  if not root then return nil end

  local directory = git_directory(root)
  local operation = git_operation(directory)
  if not operation then
    vim.notify("No rebase, merge, cherry-pick, revert, or am operation to " .. verb, vim.log.levels.INFO, {
      title = "Git " .. verb,
    })
    return nil
  end
  if not repository_ready(root, gerund .. " " .. operation.name, true, directory) then return nil end
  return root, operation
end

local function continue_git_operation()
  local root, operation = active_operation("continue", "continuing")
  if not root then return end

  run_git_in_terminal(root, operation.name .. " continue", operation.continue_args, {
    env = { GIT_EDITOR = vim.fn.shellescape(vim.v.progpath) },
    title = "Git continue",
    success_message = "Git " .. operation.name .. " completed",
    failure_message = "Git " .. operation.name .. " stopped; see the terminal for details",
  })
end

local function abort_git_operation()
  local root, operation = active_operation("abort", "aborting")
  if not root then return end

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
  local root = ready_root("amend")
  if not root then return end

  local args = refresh_date and { "commit", "--date=now", "--amend" } or { "commit", "--amend" }
  run_git_in_terminal(root, "amend", args, {
    env = { GIT_EDITOR = vim.fn.shellescape(vim.v.progpath) },
    title = "Git amend",
    success_message = refresh_date and "Commit amended with the current author date" or "Commit amended",
    failure_message = "Commit amend stopped; see the terminal for details",
  })
end

local function interactive_rebase_current_repo()
  local root = ready_root("rebase")
  if not root then return end

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

  local root = ready_root("merge")
  if not root then return end

  local target = current_branch(root)
  if not target then
    vim.notify("Cannot merge into a detached HEAD", vim.log.levels.ERROR, { title = "Git merge" })
    return
  end
  if branch == target then
    vim.notify(branch .. " is already the current branch", vim.log.levels.WARN, { title = "Git merge" })
    return
  end

  run_git_in_terminal(root, "merge", { "merge", "--", branch }, {
    env = { GIT_EDITOR = vim.fn.shellescape(vim.v.progpath) },
    title = "Git merge",
    success_message = "Merged " .. branch .. " into " .. target,
    failure_message = "Git merge stopped; see the terminal for details",
  })
end

function M.cherry_pick(commit)
  if type(commit) ~= "string" or not commit:match("^%x+$") then
    vim.notify("No commit selected", vim.log.levels.WARN, { title = "Git cherry-pick" })
    return
  end

  local root = ready_root("cherry-pick")
  if not root then return end

  run_git_in_terminal(root, "cherry-pick", { "cherry-pick", "--", commit }, {
    env = { GIT_EDITOR = vim.fn.shellescape(vim.v.progpath) },
    title = "Git cherry-pick",
    success_message = "Cherry-picked " .. commit,
    failure_message = "Git cherry-pick stopped; see the terminal for details",
  })
end

function M.can_checkout()
  local root = require_root()
  return root ~= nil and repository_ready(root, "checkout")
end

function M.status()
  local root = current_root()
  if not root then return "" end

  local parts = {}
  local tracking = status.tracking(root)
  if tracking ~= "" then table.insert(parts, tracking) end
  if status.dirty(root) or vim.bo.modified then table.insert(parts, "●") end
  if fetch_failed[root] then table.insert(parts, "!") end
  return table.concat(parts, " ")
end

function M.branch()
  local root = current_root()
  return root and status.branch(root) or ""
end

function M.refresh()
  status.update(current_root(), true)
end

function M.setup()
  if timer then return end
  local group = vim.api.nvim_create_augroup("DotfilesGit", { clear = true })

  timer = assert(vim.uv.new_timer())
  timer:start(interval, interval, vim.schedule_wrap(function()
    if focused then fetch_current_repo(true, false) end
  end))

  vim.api.nvim_create_autocmd("FocusLost", {
    group = group,
    callback = function()
      focused = false
    end,
  })
  vim.api.nvim_create_autocmd("FocusGained", {
    group = group,
    callback = function()
      focused = true
      status.update(current_root(), true)
      fetch_current_repo(false, false)
    end,
  })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function()
      if vim.bo.buftype ~= "" then return end
      status.update(current_root(), false)
      fetch_current_repo(false, false)
    end,
  })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    callback = function()
      status.update(current_root(), true)
    end,
  })
  vim.api.nvim_create_autocmd("BufModifiedSet", {
    group = group,
    callback = redraw_status,
  })

  vim.api.nvim_create_user_command("GitFetch", function()
    fetch_current_repo(true, true)
  end, { desc = "Fetch remote updates now", force = true })
  vim.api.nvim_create_user_command("GitPull", pull_current_repo, {
    desc = "Fast-forward the current branch", force = true,
  })
  vim.api.nvim_create_user_command("GitCommit", commit_current_repo, {
    desc = "Commit staged changes with a title and optional message", force = true,
  })
  vim.api.nvim_create_user_command("GitPush", push_current_repo, {
    desc = "Push HEAD to origin after confirmation", force = true,
  })
  vim.api.nvim_create_user_command("GitBranchNew", create_branch_current_repo, {
    desc = "Create and check out a new branch", force = true,
  })
  vim.api.nvim_create_user_command("GitStash", stash_current_repo, {
    desc = "Create a named stash", force = true,
  })
  vim.api.nvim_create_user_command("GitStageAll", stage_all_current_repo, {
    desc = "Stage all changes", force = true,
  })
  vim.api.nvim_create_user_command("GitUnstageAll", unstage_all_current_repo, {
    desc = "Unstage all changes without modifying the working tree", force = true,
  })
  vim.api.nvim_create_user_command("GitContinue", continue_git_operation, {
    desc = "Continue the active Git operation", force = true,
  })
  vim.api.nvim_create_user_command("GitAbort", abort_git_operation, {
    desc = "Abort the active Git operation after confirmation", force = true,
  })
  vim.api.nvim_create_user_command("GitAmend", function()
    amend_current_commit(false)
  end, { desc = "Amend the current commit in an editor", force = true })
  vim.api.nvim_create_user_command("GitAmendNow", function()
    amend_current_commit(true)
  end, { desc = "Amend the current commit with the current author date", force = true })
  vim.api.nvim_create_user_command("GitRebaseInteractive", interactive_rebase_current_repo, {
    desc = "Interactively rebase a number of recent commits", force = true,
  })

  vim.defer_fn(function()
    status.update(current_root(), false)
    fetch_current_repo(false, false)
  end, 1000)

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    once = true,
    callback = function()
      timer:stop()
      timer:close()
    end,
  })
end

return M
