local M = {}

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

-- Keep the working directory local to the current window and cache each
-- buffer's resolved root so normal buffer movement stays cheap.
function M.setup()
  local group = vim.api.nvim_create_augroup("DotfilesProjectRoot", { clear = true })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function()
      if vim.bo.buftype ~= "" then return end
      local buf = vim.api.nvim_get_current_buf()
      local path = vim.api.nvim_buf_get_name(buf)
      if path == "" then return end
      local cached_path = vim.b[buf].project_root_path
      local root = vim.b[buf].project_root
      if cached_path == path then
        if root then vim.cmd.lcd(vim.fn.fnameescape(root)) end
        return
      end

      root = M.root(path)
      vim.b[buf].project_root_path = path
      vim.b[buf].project_root = root
      if root then vim.cmd.lcd(vim.fn.fnameescape(root)) end
    end,
  })
end

return M
