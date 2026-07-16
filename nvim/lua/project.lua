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

return M
