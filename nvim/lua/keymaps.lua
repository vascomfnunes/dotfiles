local map = vim.keymap.set
local opts = { silent = true }
local uv = vim.uv
local lazy = require("lazyload")
local M = {}

-- Leader key
vim.g.mapleader = " "

-- Seamless window movement/resizing across Neovim and tmux.
map("n", "<C-h>", function() require("splits").move("left") end, opts)
map("n", "<C-j>", function() require("splits").move("down") end, opts)
map("n", "<C-k>", function() require("splits").move("up") end, opts)
map("n", "<C-l>", function() require("splits").move("right") end, opts)
map("n", "<M-h>", function() require("splits").resize("left") end, opts)
map("n", "<M-j>", function() require("splits").resize("down") end, opts)
map("n", "<M-k>", function() require("splits").resize("up") end, opts)
map("n", "<M-l>", function() require("splits").resize("right") end, opts)

-- Core editing
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>e", function()
  lazy.mini_files()
  -- Unnamed or deleted-file buffers have no path mini.files can open.
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or not uv.fs_stat(path) then path = nil end
  require("mini.files").open(path, true)
end, { desc = "Explorer" })

-- Copy file/line references in a format coding agents can resolve directly.
function M.file_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr or 0)
  if name == "" then return nil end
  return vim.fn.fnamemodify(name, ":p")
end

function M.location(path, first, last)
  if last == nil or last == first then return ("%s:%d"):format(path, first) end
  return ("%s:%d-%d"):format(path, first, last)
end

local function copy_reference(first, last)
  local path = M.file_path()
  if not path then
    vim.notify("Current buffer is not a file", vim.log.levels.WARN)
    return
  end

  local reference = M.location(path, first, last)
  vim.fn.setreg("+", reference)
  vim.notify("Copied: " .. reference, vim.log.levels.INFO)
end

map("n", "<leader>al", function()
  copy_reference(vim.fn.line("."))
end, { desc = "Copy line reference" })

map("x", "<leader>al", function()
  local mode = vim.fn.mode()
  local anchor = vim.fn.getpos("v")
  local cursor = vim.fn.getpos(".")
  local start_pos, end_pos = anchor, cursor
  if anchor[2] > cursor[2] or (anchor[2] == cursor[2] and anchor[3] > cursor[3]) then
    start_pos, end_pos = cursor, anchor
  end

  -- Leave visual mode, then drop the last line when a charwise selection stops
  -- at the very start of it.
  vim.cmd("normal! \27")
  local first, last = start_pos[2], end_pos[2]
  if mode == "v" and last > first and end_pos[3] == 1 then
    last = last - 1
  end

  copy_reference(first, last)
end, { desc = "Copy line range reference" })

map("n", "<leader>af", function()
  local path = M.file_path()
  if not path then
    vim.notify("Current buffer is not a file", vim.log.levels.WARN)
    return
  end

  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy file path" })

map("n", "<leader>ql", function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end, { desc = "Toggle quickfix" })

local quickfix_group = vim.api.nvim_create_augroup("DotfilesQuickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = quickfix_group,
  pattern = "qf",
  callback = function(ev)
    local function quickfix_map(lhs, rhs, desc)
      map("n", lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
    end

    quickfix_map("<C-j>", "j", "Next quickfix entry")
    quickfix_map("<C-k>", "k", "Previous quickfix entry")
    quickfix_map("<C-l>", "<CR>", "Open quickfix entry")
  end,
})

map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Native LSP completion keeps selection explicit: choose an item first, then
-- Enter accepts it. Otherwise Enter retains its normal newline behavior.
map("i", "<C-Space>", function() vim.lsp.completion.get() end, { desc = "Complete" })
map("i", "<C-j>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { expr = true, desc = "Next completion or newline" })
map("i", "<C-k>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, { expr = true, desc = "Previous completion or digraph" })
map("i", "<C-l>", function()
  if vim.fn.pumvisible() ~= 1 then return "<C-l>" end

  local completion = vim.fn.complete_info({ "selected" })
  return completion.selected >= 0 and "<C-y>" or "<C-n><C-y>"
end, { expr = true, desc = "Accept completion" })
map("i", "<CR>", function()
  local completion = vim.fn.complete_info({ "selected" })
  return vim.fn.pumvisible() == 1 and completion.selected >= 0 and "<C-y>" or "<CR>"
end, { expr = true, desc = "Accept completion or newline" })

local editing_group = vim.api.nvim_create_augroup("DotfilesEditing", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = editing_group,
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Jump back to the last cursor position when reopening a file. Skip commit
-- messages: starting at the top is the point there.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = editing_group,
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= "" then return end
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if name:match("COMMIT_EDITMSG$") or name:match("MERGE_MSG$") then return end
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Pinned files
map("n", "<leader>m", function() require("pins").toggle() end, { desc = "Pin/unpin file" })
map("n", "<leader>M", function() require("pins").pick() end, { desc = "Pinned files" })
for index = 1, 4 do
  map("n", "<leader>" .. index, function() require("pins").jump(index) end, { desc = "Pin #" .. index })
end

-- Sessions
map("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "Restore session" })

-- Tab navigation (<Tab>=<C-i> in terminals, so use leader to preserve jumplist)
map("n", "<leader><Tab>", "gt", { desc = "Next tab" })
map("n", "<leader><S-Tab>", "gT", { desc = "Prev tab" })

-- Navigation (Flash)
map({ "n", "x", "o" }, "s", function()
  lazy.flash()
  require("flash").jump()
end, { desc = "Flash" })

-- Fzf-lua
-- Each picker loads fzf-lua on first use.
local function fzf(command, fzf_opts)
  return function()
    lazy.fzf()
    require("fzf-lua")[command](fzf_opts)
  end
end

-- LSP
map("n", "gd", function() require("tags").definition_or_tag() end, { desc = "Go to definition" })
map("n", "<C-]>", function() require("tags").definition_or_tag() end, { desc = "Go to definition" })
map("n", "grr", fzf("lsp_references"), { desc = "References" })
map("n", "gri", fzf("lsp_implementations", { jump1 = true }), { desc = "Implementations" })
map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code action" })
map("n", "<leader>cr", function() vim.lsp.buf.rename() end, { desc = "Rename symbol" })
map("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
map("n", "<leader>ch", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle inlay hints" })

map("n", "<leader>fb", fzf("buffers"), { desc = "Buffers" })
map("n", "<leader>ff", fzf("files"), { desc = "Files" })
map("n", "<leader>fg", fzf("live_grep"), { desc = "Grep" })
map("n", "<leader>fw", fzf("grep_cword"), { desc = "Grep word" })
map("n", "<leader>fr", fzf("resume"), { desc = "Resume" })

require("git.keymaps").setup(fzf)

-- Rails/Ruby
local function rails_find_files(cwd, prompt_title)
  if uv.fs_stat(cwd) == nil then
    vim.notify(("Missing directory: %s"):format(cwd), vim.log.levels.WARN)
    return
  end
  lazy.fzf()
  require("fzf-lua").files({ cwd = cwd, prompt = prompt_title .. "> " })
end

map("n", "<leader>rm", function() rails_find_files("app/models", "Models") end, { desc = "Find Models" })
map("n", "<leader>rc", function() rails_find_files("app/controllers", "Controllers") end, { desc = "Find Controllers" })
map("n", "<leader>rv", function() rails_find_files("app/views", "Views") end, { desc = "Find Views" })
map("n", "<leader>rs", function() rails_find_files("spec", "Specs") end, { desc = "Find Specs" })

-- Testing
map("n", "<leader>tr", function()
  lazy.neotest()
  require("neotest").run.run()
end, { desc = "Run nearest" })
map("n", "<leader>tf", function()
  lazy.neotest()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run file" })
map("n", "<leader>tt", function()
  lazy.neotest()
  require("neotest").summary.toggle()
end, { desc = "Toggle summary" })
map("n", "<leader>tl", function()
  lazy.neotest()
  require("neotest").run.run_last()
end, { desc = "Run last" })
map("n", "<leader>to", function()
  lazy.neotest()
  require("neotest").output.open({ enter = true })
end, { desc = "Show output" })

-- UI
map("n", "<leader>cx", function()
  local list = vim.fn.getqflist({ title = 0, winid = 0 })
  if list.winid ~= 0 and list.title == "Diagnostics" then
    vim.cmd.cclose()
  else
    vim.diagnostic.setqflist({ title = "Diagnostics", open = true })
  end
end, { desc = "Diagnostics" })
map("n", "<leader>co", fzf("lsp_document_symbols"), { desc = "Document outline" })
map("n", "<leader>fS", function()
  lazy.grug_far()
  require("grug-far").open()
end, { desc = "Search & Replace" })

-- Pack management
vim.api.nvim_create_user_command("PackUpdate", function()
  require("packs").install_all()
  vim.pack.update()
end, { desc = "Update plugins", force = true })
vim.api.nvim_create_user_command("PackRestore", function()
  require("packs").install_all()
  vim.pack.update(nil, { target = "lockfile" })
end, { desc = "Restore plugins from lockfile", force = true })
map("n", "<leader>pu", "<cmd>PackUpdate<cr>", { desc = "Update plugins" })
map("n", "<leader>ps", "<cmd>PackRestore<cr>", { desc = "Restore plugins from lockfile" })

return M
