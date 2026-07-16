local M = {}
local paths = {}

function M.path(root)
  if not root or root == "" then return nil end
  if paths[root] then return paths[root] end

  local result = vim.system({
    "git", "-C", root, "rev-parse", "--path-format=absolute", "--git-path", "tags",
  }, { text = true }):wait()
  local path = result.code == 0 and vim.trim(result.stdout or "") or ""
  if path == "" then path = root .. "/tags" end
  paths[root] = path
  return path
end

function M.with_file(bufnr, path, callback)
  return vim.api.nvim_buf_call(bufnr, function()
    local original = vim.bo[bufnr].tags
    local escaped = vim.fn.fnameescape(path):gsub(",", "\\,")
    vim.bo[bufnr].tags = escaped .. "," .. original
    local result = { pcall(callback) }
    vim.bo[bufnr].tags = original
    if not result[1] then error(result[2]) end
    return unpack(result, 2)
  end)
end

return M
