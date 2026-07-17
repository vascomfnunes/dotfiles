-- Pin a handful of files per project and jump to them by number.
-- Pins persist in one JSON file keyed by the directory Neovim started in.
local M = {}

local store = vim.fn.stdpath("state") .. "/pins.json"

local function project_key()
  return vim.fn.getcwd(-1, -1)
end

local function read_store()
  local file = io.open(store, "r")
  if not file then return {} end
  local content = file:read("*a")
  file:close()
  local ok, data = pcall(vim.json.decode, content)
  return (ok and type(data) == "table") and data or {}
end

local function write_store(data)
  local file = assert(io.open(store, "w"))
  file:write(vim.json.encode(data))
  file:close()
end

local function pins()
  return read_store()[project_key()] or {}
end

local function current_file()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or vim.bo.buftype ~= "" then return nil end
  return vim.fs.relpath(project_key(), path) or path
end

local function open(path)
  if not path:match("^/") then path = project_key() .. "/" .. path end
  vim.cmd.edit(vim.fn.fnameescape(path))
end

function M.toggle()
  local path = current_file()
  if not path then return end
  local data = read_store()
  local list = data[project_key()] or {}
  for index, pinned in ipairs(list) do
    if pinned == path then
      table.remove(list, index)
      data[project_key()] = #list > 0 and list or nil
      write_store(data)
      vim.notify("Unpinned " .. path)
      return
    end
  end
  list[#list + 1] = path
  data[project_key()] = list
  write_store(data)
  vim.notify(("Pinned %s (#%d)"):format(path, #list))
end

function M.jump(index)
  local path = pins()[index]
  if not path then
    vim.notify("No pin #" .. index, vim.log.levels.WARN)
    return
  end
  open(path)
end

function M.pick()
  local list = pins()
  if #list == 0 then
    vim.notify("No pins in this project", vim.log.levels.WARN)
    return
  end
  vim.ui.select(list, { prompt = "Pins" }, function(choice)
    if choice then open(choice) end
  end)
end

return M
