local M = {}
local selected_root

local function existing_ancestor(path)
  local directory = vim.fs.dirname(path)

  while directory and not vim.uv.fs_stat(directory) do
    local parent = vim.fs.dirname(directory)
    if not parent or parent == directory then return nil end
    directory = parent
  end

  return directory
end

function M.root(path)
  return vim.fs.root(path, { ".git", "Gemfile", "package.json" }) or existing_ancestor(path)
end

local function change_directory(root)
  if root and vim.fn.getcwd(0) ~= root then
    vim.cmd.lcd(vim.fn.fnameescape(root))
  end
end

function M.select(path)
  path = vim.fn.fnamemodify(vim.fn.expand(path), ":p")
  local stat = vim.uv.fs_stat(path)
  if not stat or stat.type ~= "directory" then
    vim.notify("Not a directory: " .. path, vim.log.levels.WARN)
    return false
  end
  selected_root = vim.fs.normalize(path)
  vim.cmd.cd(vim.fn.fnameescape(selected_root))
  vim.notify("Project: " .. selected_root)
  return true
end

-- Keep the working directory local to the current window and cache each
-- buffer's resolved root so normal buffer movement stays cheap.
function M.setup()
  local group = vim.api.nvim_create_augroup("DotfilesProjectRoot", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      vim.keymap.set("n", "gp", function()
        local files = require("mini.files")
        local entry = files.get_fs_entry()
        if not entry or entry.fs_type ~= "directory" then
          vim.notify("Select a directory", vim.log.levels.WARN)
          return
        end
        files.close()
        M.select(entry.path)
      end, { buffer = args.data.buf_id, desc = "Set project directory" })
    end,
  })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function()
      if vim.bo.buftype ~= "" then return end
      if selected_root then
        change_directory(selected_root)
        return
      end
      local buf = vim.api.nvim_get_current_buf()
      local path = vim.api.nvim_buf_get_name(buf)
      if path == "" then return end
      local cached_path = vim.b[buf].project_root_path
      local root = vim.b[buf].project_root
      if cached_path == path then
        change_directory(root)
        return
      end

      root = M.root(path)
      vim.b[buf].project_root_path = path
      vim.b[buf].project_root = root
      change_directory(root)
    end,
  })
end

return M
