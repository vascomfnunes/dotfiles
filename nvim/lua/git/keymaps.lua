local M = {}
local map = vim.keymap.set
local selected_git_branch = require("git.parsers").selected_branch

local function current_git_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Current buffer is not a file", vim.log.levels.WARN)
    return nil
  end

  local result = vim.system(
    { "git", "rev-parse", "--show-toplevel" },
    { cwd = vim.fn.fnamemodify(file, ":h"), text = true }
  ):wait()
  if result.code ~= 0 then
    vim.notify("Current buffer is not inside a git repository", vim.log.levels.WARN)
    return nil
  end

  local root = vim.trim(result.stdout)
  local relative = vim.fs.relpath(root, file)
  if not relative then
    vim.notify("Current file is outside the git repository", vim.log.levels.WARN)
    return nil
  end

  return relative, file
end

local function copy_git_output(args, label)
  local result = vim.system(args, { text = true }):wait()
  if result.code ~= 0 then
    vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
    return
  end

  local output = vim.trim(result.stdout)
  if output == "" then return end
  vim.fn.setreg("+", output)
  vim.notify(label .. ": " .. output, vim.log.levels.INFO)
end

local function gitsigns_action(action)
  return function()
    vim.g.dotfiles_lazy.gitsigns()
    require("gitsigns")[action]()
  end
end

function M.setup(fzf)
  map("n", "<leader>gc", "<cmd>GitCommit<CR>", { desc = "Commit staged changes" })
  map("n", "<leader>gp", "<cmd>GitPull<CR>", { desc = "Pull (fast-forward only)" })
  map("n", "<leader>gP", "<cmd>GitPush<CR>", { desc = "Push HEAD to origin" })
  map("n", "<leader>gf", "<cmd>GitFetch<CR>", { desc = "Fetch remote updates" })
  map("n", "<leader>gi", "<cmd>GitRebaseInteractive<CR>", { desc = "Interactive rebase" })
  map("n", "<leader>gk", "<cmd>GitContinue<CR>", { desc = "Continue Git operation" })
  map("n", "<leader>gQ", "<cmd>GitAbort<CR>", { desc = "Abort Git operation" })
  map("n", "<leader>ga", "<cmd>GitAmend<CR>", { desc = "Amend commit" })
  map("n", "<leader>gA", "<cmd>GitAmendNow<CR>", { desc = "Amend commit with current date" })
  map("n", "<leader>gm", function()
    vim.g.dotfiles_lazy.fzf()
    require("fzf-lua").git_branches({
      prompt = "Merge branch> ",
      actions = {
        ["enter"] = function(selected)
          local branch = selected_git_branch(selected)
          if not branch then
            vim.notify("Unable to parse branch: " .. tostring(selected[1]), vim.log.levels.ERROR)
            return
          end
          require("git").merge(branch)
        end,
      },
    })
  end, { desc = "Merge branch" })
  map("n", "<leader>gn", "<cmd>GitBranchNew<CR>", { desc = "Create new branch" })
  map("n", "<leader>gC", function()
    local git = require("git")
    if not git.can_checkout() then return end
    vim.g.dotfiles_lazy.fzf()
    local actions = require("fzf-lua.actions")
    require("fzf-lua").git_branches({
      prompt = "Checkout branch> ",
      actions = {
        ["enter"] = function(selected, opts)
          actions.git_switch(selected, opts)
          git.refresh()
        end,
      },
    })
  end, { desc = "Checkout branch" })
  map("n", "<leader>gs", fzf("git_status"), { desc = "Status / changed files" })

  map("n", "<leader>gyb", function()
    copy_git_output({ "git", "branch", "--show-current" }, "Copied branch")
  end, { desc = "Copy branch" })
  map("n", "<leader>gyc", function()
    copy_git_output({ "git", "rev-parse", "--short", "HEAD" }, "Copied commit")
  end, { desc = "Copy commit" })

  map("n", "<leader>gb", function()
    vim.g.dotfiles_lazy.fzf()
    require("fzf-lua").git_branches({
      prompt = "Compare branch> ",
      actions = {
        ["enter"] = function(selected)
          local branch = selected_git_branch(selected)
          if not branch then
            vim.notify("Unable to parse branch: " .. tostring(selected[1]), vim.log.levels.ERROR)
            return
          end
          vim.g.dotfiles_lazy.codediff()
          vim.cmd("CodeDiff " .. vim.fn.fnameescape(branch .. "..."))
        end,
      },
    })
  end, { desc = "Compare branch" })
  map("n", "<leader>gF", function()
    if not current_git_file() then return end
    vim.g.dotfiles_lazy.fzf()
    require("fzf-lua").git_branches({
      prompt = "Compare file branch> ",
      actions = {
        ["enter"] = function(selected)
          local branch = selected_git_branch(selected)
          if not branch then
            vim.notify("Unable to parse branch: " .. tostring(selected[1]), vim.log.levels.ERROR)
            return
          end
          vim.g.dotfiles_lazy.codediff()
          vim.cmd("CodeDiff file " .. vim.fn.fnameescape(branch))
        end,
      },
    })
  end, { desc = "Compare file with branch" })
  map("n", "<leader>gd", function()
    vim.g.dotfiles_lazy.codediff()
    vim.cmd.CodeDiff()
  end, { desc = "Diff project" })
  map("n", "<leader>gh", function()
    local _, file = current_git_file()
    if not file then return end
    vim.g.dotfiles_lazy.codediff()
    vim.cmd("CodeDiff history " .. vim.fn.fnameescape(file))
  end, { desc = "File history" })
  map("n", "<leader>gL", function()
    if not require("git").can_checkout() then return end
    vim.g.dotfiles_lazy.fzf()
    require("fzf-lua").git_reflog()
  end, { desc = "Reflog" })

  map("n", "<leader>gt", fzf("git_stash"), { desc = "Stashes" })
  map("n", "<leader>gT", "<cmd>GitStash<CR>", { desc = "Create stash" })
  map("n", "<leader>gr", gitsigns_action("reset_hunk"), { desc = "Reset hunk" })
  map("n", "<leader>gR", gitsigns_action("reset_buffer"), { desc = "Reset buffer" })
end

return M
