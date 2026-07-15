local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local uv = vim.uv

-- Leader key
vim.g.mapleader = " "

-- Seamless window movement/resizing across Neovim and tmux.
map("n", "<C-h>", function() require("smart-splits").move_cursor_left() end, opts)
map("n", "<C-j>", function() require("smart-splits").move_cursor_down() end, opts)
map("n", "<C-k>", function() require("smart-splits").move_cursor_up() end, opts)
map("n", "<C-l>", function() require("smart-splits").move_cursor_right() end, opts)
map("n", "<M-h>", function() require("smart-splits").resize_left() end, opts)
map("n", "<M-j>", function() require("smart-splits").resize_down() end, opts)
map("n", "<M-k>", function() require("smart-splits").resize_up() end, opts)
map("n", "<M-l>", function() require("smart-splits").resize_right() end, opts)

-- Core editing
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>e", function()
  vim.g.dotfiles_lazy.mini_files()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Explorer" })

map("n", "<leader>ql", function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end, { desc = "Toggle quickfix" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Tab navigation (<Tab>=<C-i> in terminals, so use leader to preserve jumplist)
map("n", "<leader><Tab>", "gt", { desc = "Next tab" })
map("n", "<leader><S-Tab>", "gT", { desc = "Prev tab" })

-- Navigation (Flash)
map({ "n", "x", "o" }, "s", function()
  vim.g.dotfiles_lazy.flash()
  require("flash").jump()
end, { desc = "Flash" })

-- Git helpers
map("n", "<leader>gn", function()
  local newbranch = vim.fn.input("New branch name: ")
  if newbranch ~= "" then
    local result = vim.system({ "git", "checkout", "-b", newbranch }):wait()
    if result.code ~= 0 then
      vim.notify("Failed to create branch: " .. newbranch, vim.log.levels.ERROR)
    else
      vim.notify("Created branch: " .. newbranch, vim.log.levels.INFO)
    end
  end
end, { desc = "Create new branch" })

-- Fzf-lua
-- Each picker loads fzf-lua on first use.
local function fzf(command, fzf_opts)
  return function()
    vim.g.dotfiles_lazy.fzf()
    require("fzf-lua")[command](fzf_opts)
  end
end

-- LSP
map("n", "gd", fzf("lsp_definitions", { jump1 = true }), { desc = "Go to definition" })
map("n", "grr", fzf("lsp_references"), { desc = "References" })
map("n", "gri", fzf("lsp_implementations", { jump1 = true }), { desc = "Implementations" })
map("n", "K", function() vim.lsp.buf.hover() end, { desc = "Hover docs" })
map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code action" })
map("n", "<leader>cr", function() vim.lsp.buf.rename() end, { desc = "Rename symbol" })
map("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
map("n", "<leader>ch", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle inlay hints" })

local function selected_git_branch(selected)
  if not selected[1] then return nil end
  return selected[1]:match("^[%*+]*[%s]*[(]?([^%s)]+)")
end

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

  return relative
end

local function git_output(args)
  local result = vim.system(args, { text = true }):wait()
  if result.code ~= 0 then
    vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
    return nil
  end

  return vim.trim(result.stdout)
end

local function copy_git_output(args, label)
  local output = git_output(args)
  if not output or output == "" then return end

  vim.fn.setreg("+", output)
  vim.notify(label .. ": " .. output, vim.log.levels.INFO)
end

local function gitsigns_action(action)
  return function()
    vim.g.dotfiles_lazy.gitsigns()
    require("gitsigns")[action]()
  end
end

map("n", "<leader>fb", fzf("buffers"), { desc = "Buffers" })
map("n", "<leader>ff", fzf("files"), { desc = "Files" })
map("n", "<leader>fs", fzf("lsp_document_symbols"), { desc = "Document symbols" })
map("n", "<leader>fg", fzf("live_grep"), { desc = "Grep" })
map("n", "<leader>fw", fzf("grep_cword"), { desc = "Grep word" })
map("n", "<leader>fr", fzf("resume"), { desc = "Resume" })

-- Git Plugins
map("n", "<leader>gg", function()
  vim.g.dotfiles_lazy.neogit()
  require("neogit").open()
end, { desc = "Neogit" })
map("n", "<leader>gx", "<cmd>GitFetch<CR>", { desc = "Fetch remote updates" })
map("n", "<leader>gP", "<cmd>GitPull<CR>", { desc = "Pull (fast-forward only)" })
map("n", "<leader>gc", function()
  copy_git_output({ "git", "branch", "--show-current" }, "Copied branch")
end, { desc = "Copy branch" })
map("n", "<leader>gC", function()
  copy_git_output({ "git", "rev-parse", "--short", "HEAD" }, "Copied commit")
end, { desc = "Copy commit" })
map("n", "<leader>gf", fzf("git_status"), { desc = "Changed files" })
map("n", "<leader>go", fzf("git_branches"), { desc = "Checkout branch" })
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
map("n", "<leader>gB", function()
  local file = current_git_file()
  if not file then return end

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
map("n", "<leader>gs", fzf("git_stash"), { desc = "Stashes" })
map("n", "<leader>gS", function()
  local message = vim.fn.input("Stash message: ")
  if message == "" then return end

  local result = vim.system({ "git", "stash", "push", "-m", message }, { text = true }):wait()
  if result.code ~= 0 then
    vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
    return
  end

  vim.notify(vim.trim(result.stdout), vim.log.levels.INFO)
end, { desc = "Create stash" })
map("n", "<leader>gp", gitsigns_action("preview_hunk"), { desc = "Preview hunk" })
map("n", "<leader>gr", gitsigns_action("reset_hunk"), { desc = "Reset hunk" })
map("n", "<leader>gR", gitsigns_action("reset_buffer"), { desc = "Reset buffer" })
map("n", "<leader>gd", function()
  vim.g.dotfiles_lazy.codediff()
  vim.cmd.CodeDiff()
end, { desc = "Diff Project" })
map("n", "<leader>gF", function()
  vim.g.dotfiles_lazy.codediff()
  vim.cmd("CodeDiff history %")
end, { desc = "File History" })

-- Rails/Ruby
local function rails_find_files(cwd, prompt_title)
  if uv.fs_stat(cwd) == nil then
    vim.notify(("Missing directory: %s"):format(cwd), vim.log.levels.WARN)
    return
  end
  vim.g.dotfiles_lazy.fzf()
  require("fzf-lua").files({ cwd = cwd, prompt = prompt_title .. "> " })
end

map("n", "<leader>rm", function() rails_find_files("app/models", "Models") end, { desc = "Find Models" })
map("n", "<leader>rc", function() rails_find_files("app/controllers", "Controllers") end, { desc = "Find Controllers" })
map("n", "<leader>rv", function() rails_find_files("app/views", "Views") end, { desc = "Find Views" })
map("n", "<leader>rs", function() rails_find_files("spec", "Specs") end, { desc = "Find Specs" })

-- Testing
map("n", "<leader>tr", function()
  vim.g.dotfiles_lazy.neotest()
  require("neotest").run.run()
end, { desc = "Run nearest" })
map("n", "<leader>tf", function()
  vim.g.dotfiles_lazy.neotest()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run file" })
map("n", "<leader>tt", function()
  vim.g.dotfiles_lazy.neotest()
  require("neotest").summary.toggle()
end, { desc = "Toggle summary" })
map("n", "<leader>tl", function()
  vim.g.dotfiles_lazy.neotest()
  require("neotest").run.run_last()
end, { desc = "Run last" })
map("n", "<leader>to", function()
  vim.g.dotfiles_lazy.neotest()
  require("neotest").output.open({ enter = true })
end, { desc = "Show output" })

-- AI (agentic.nvim)
-- Wrap agentic.nvim calls so the plugin only loads when an AI mapping is used.
local function agentic(fn, ...)
  local args = { ... }
  return function()
    vim.g.dotfiles_lazy.agentic()
    require("agentic")[fn](unpack(args))
  end
end

map({ "n", "v" }, "<leader>aa", agentic("toggle"), { desc = "Toggle chat" })
map({ "n", "v" }, "<leader>ac", agentic("add_selection_or_file_to_context"), { desc = "Add file/selection to context" })
map("n", "<leader>ad", agentic("add_current_line_diagnostics"), { desc = "Add line diagnostics" })
map("n", "<leader>aD", agentic("add_buffer_diagnostics"), { desc = "Add buffer diagnostics" })
map("n", "<leader>an", agentic("new_session"), { desc = "New session" })
map("n", "<leader>ar", agentic("restore_session"), { desc = "Restore session" })
map("n", "<leader>as", agentic("stop_generation"), { desc = "Stop generation" })
map("n", "<leader>ap", agentic("switch_provider"), { desc = "Switch provider" })
map("n", "<leader>al", agentic("rotate_layout"), { desc = "Rotate layout" })

-- UI
map("n", "<leader>cx", function()
  vim.g.dotfiles_lazy.trouble()
  vim.cmd("Trouble diagnostics toggle")
end, { desc = "Diagnostics" })
map("n", "<leader>co", function()
  vim.g.dotfiles_lazy.outline()
  vim.cmd.Outline()
end, { desc = "Toggle outline" })
map("n", "<leader>fS", function()
  vim.g.dotfiles_lazy.grug_far()
  require("grug-far").open()
end, { desc = "Search & Replace" })

-- Pack management
vim.api.nvim_create_user_command("PackUpdate", function()
  require("packs").install_all()
  vim.pack.update()
end, { desc = "Update plugins" })
vim.api.nvim_create_user_command("PackSync", function()
  require("packs").install_all()
  vim.pack.update(nil, { target = "lockfile" })
end, { desc = "Sync lockfile" })
map("n", "<leader>pu", "<cmd>PackUpdate<cr>", { desc = "Update plugins" })
map("n", "<leader>ps", "<cmd>PackSync<cr>", { desc = "Sync lockfile" })
