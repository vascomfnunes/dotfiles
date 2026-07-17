-- Per-project sessions keyed by the directory Neovim was started in.
-- Saved automatically on exit; restored explicitly with :SessionRestore.
local M = {}

local session_dir = vim.fn.stdpath("state") .. "/sessions"

local function session_file()
  -- Global cwd only: per-window :lcd from project-root detection must not
  -- fragment sessions across windows.
  local cwd = vim.fn.getcwd(-1, -1)
  return session_dir .. "/" .. cwd:gsub("[/:]", "%%") .. ".vim"
end

local function has_file_buffer()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
      return true
    end
  end
  return false
end

function M.save()
  -- An empty session (e.g. quitting right after startup) would overwrite a
  -- useful one.
  if not has_file_buffer() then return end
  vim.fn.mkdir(session_dir, "p")
  vim.cmd("mksession! " .. vim.fn.fnameescape(session_file()))
end

function M.restore()
  local file = session_file()
  if not vim.uv.fs_stat(file) then
    vim.notify("No session for " .. vim.fn.getcwd(-1, -1), vim.log.levels.WARN)
    return
  end
  vim.cmd("silent! source " .. vim.fn.fnameescape(file))
end

function M.setup()
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("DotfilesSessions", { clear = true }),
    callback = M.save,
  })
  vim.api.nvim_create_user_command("SessionRestore", M.restore, {
    desc = "Restore the session for this directory",
    force = true,
  })
end

return M
