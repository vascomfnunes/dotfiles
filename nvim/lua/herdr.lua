local M = {}

local wincmd_for = {
  left = "h",
  down = "j",
  up = "k",
  right = "l",
}

local DEFAULT_RESIZE_AMOUNT = 3
local HERDR_RESIZE_AMOUNT = "0.05"

function M.in_herdr()
  return vim.env.HERDR_ENV == "1" and (vim.env.HERDR_PANE_ID or "") ~= ""
end

function M.marker_path()
  if not M.in_herdr() then return nil end
  local cache = vim.env.XDG_CACHE_HOME
  if not cache or cache == "" then
    cache = (vim.env.HOME or "") .. "/.cache"
  end
  return cache .. "/herdr/nvim-panes/" .. vim.env.HERDR_PANE_ID
end

local function write_marker()
  local path = M.marker_path()
  if not path then return end
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  pcall(vim.fn.writefile, { tostring(vim.fn.getpid()), vim.v.servername or "" }, path)
end

local function remove_marker()
  local path = M.marker_path()
  if not path then return end
  local ok, lines = pcall(vim.fn.readfile, path, "", 1)
  if ok and lines[1] == tostring(vim.fn.getpid()) then
    pcall(vim.uv.fs_unlink, path)
  end
end

local function herdr_cmd(args)
  local cmd = { "herdr" }
  vim.list_extend(cmd, args)
  vim.system(cmd)
end

function M.setup()
  if not M.in_herdr() then return end

  write_marker()

  local group = vim.api.nvim_create_augroup("DotfilesHerdr", { clear = true })
  vim.api.nvim_create_autocmd("VimResume", {
    group = group,
    callback = write_marker,
  })
  vim.api.nvim_create_autocmd({ "VimSuspend", "VimLeavePre" }, {
    group = group,
    callback = remove_marker,
  })
end

function M.move(direction)
  local key = wincmd_for[direction]
  if not key then return end

  local before = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. key)
  if vim.api.nvim_get_current_win() == before and M.in_herdr() then
    herdr_cmd({ "pane", "focus", "--current", "--direction", direction })
  end
end

function M.resize(direction, amount)
  if not wincmd_for[direction] then return end
  amount = amount or DEFAULT_RESIZE_AMOUNT

  local cur = vim.fn.winnr()
  if direction == "left" or direction == "right" then
    local has_neighbor = vim.fn.winnr("h") ~= cur or vim.fn.winnr("l") ~= cur
    if has_neighbor then
      local at_right = vim.fn.winnr("l") == cur
      local grow = (direction == "left" and at_right) or (direction == "right" and not at_right)
      vim.cmd(("vertical resize %s%d"):format(grow and "+" or "-", amount))
      return
    end
  else
    local has_neighbor = vim.fn.winnr("k") ~= cur or vim.fn.winnr("j") ~= cur
    if has_neighbor then
      local at_bottom = vim.fn.winnr("j") == cur
      local grow = (direction == "up" and at_bottom) or (direction == "down" and not at_bottom)
      vim.cmd(("resize %s%d"):format(grow and "+" or "-", amount))
      return
    end
  end

  if M.in_herdr() then
    herdr_cmd({
      "pane", "resize", "--current",
      "--direction", direction,
      "--amount", HERDR_RESIZE_AMOUNT,
    })
  end
end

function M.split(direction)
  if direction == "right" then
    vim.cmd("vsplit")
    return 1
  elseif direction == "down" then
    vim.cmd("split")
    return 1
  end
  return 0
end

return M
