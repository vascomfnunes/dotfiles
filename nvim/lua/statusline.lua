local M = {}

local progress_groups = {}
local progress = ""

local mode_names = {
  n = "NORMAL",
  no = "O-PENDING",
  nov = "O-PENDING",
  noV = "O-PENDING",
  ["no\22"] = "O-PENDING",
  niI = "NORMAL",
  niR = "NORMAL",
  niV = "NORMAL",
  nt = "NORMAL",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
  i = "INSERT",
  ic = "INSERT",
  ix = "INSERT",
  R = "REPLACE",
  Rc = "REPLACE",
  Rx = "REPLACE",
  Rv = "V-REPLACE",
  Rvc = "V-REPLACE",
  Rvx = "V-REPLACE",
  c = "COMMAND",
  cv = "EX",
  r = "PROMPT",
  rm = "MORE",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  t = "TERMINAL",
}

local function escape(value)
  return (tostring(value or ""):gsub("%%", "%%%%"))
end

local function render_progress()
  local parts = {}
  local keys = vim.tbl_keys(progress_groups)
  table.sort(keys)
  for _, key in ipairs(keys) do
    local group = progress_groups[key]
    local message = group.title
    if group.message and not group.message:match("^%d+%%") then
      message = message .. ": " .. group.message
    end
    if group.percentage then
      message = string.format("%d%% %s", group.percentage, message)
    end
    parts[#parts + 1] = message
  end
  progress = vim.fn.strcharpart(table.concat(parts, " | "), 0, 60)
  vim.cmd.redrawstatus()
end

local function render_window(active)
  local filename = vim.fn.expand("%:t")
  if filename == "" then filename = "[No Name]" end
  if vim.bo.readonly then filename = filename .. " [RO]" end
  if vim.bo.modified then filename = filename .. " [+]" end
  local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "plain"

  if not active then
    return table.concat({
      "%#StatusLineNC# ", "%<", escape(filename), "%=", escape(filetype), "  %l:%c ",
    })
  end

  local mode = mode_names[vim.api.nvim_get_mode().mode] or "NORMAL"
  local branch = require("git").branch()
  local git_status = require("git").status()

  local git = ""
  if branch ~= "" then git = " " .. branch end
  if git_status ~= "" then git = git .. (git ~= "" and " " or "") .. git_status end

  local activity = progress
  if vim.g.gemtags_running then
    activity = activity .. (activity ~= "" and " | " or "") .. "generating tags…"
  end

  return table.concat({
    "%#DotfilesStatusMode# ", escape(mode), " ",
    "%#StatusLine# ", escape(git), git ~= "" and "  " or "", "%<", escape(filename),
    "%=", activity ~= "" and (escape(activity) .. "  ") or "",
    escape(filetype), "  %p%%  %l:%c ",
  })
end

function M.render()
  local current = vim.api.nvim_get_current_win()
  local target = tonumber(vim.g.statusline_winid) or current
  if target ~= current and vim.api.nvim_win_is_valid(target) then
    return vim.api.nvim_win_call(target, function() return render_window(false) end)
  end
  return render_window(true)
end

function M.setup()
  vim.o.statusline = "%!v:lua.require'statusline'.render()"
  local group = vim.api.nvim_create_augroup("DotfilesStatusline", { clear = true })

  local function highlights()
    vim.api.nvim_set_hl(0, "DotfilesStatusMode", { link = "Keyword" })
  end
  highlights()
  vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = highlights })

  vim.api.nvim_create_autocmd("LspProgress", {
    group = group,
    callback = function(ev)
      local value = ev.data.params.value
      if type(value) ~= "table" or not value.kind then return end
      local key = ev.data.client_id .. ":" .. tostring(ev.data.params.token)
      if value.kind == "end" then
        progress_groups[key] = nil
      else
        local group = progress_groups[key] or {}
        group.title = value.title or group.title or ""
        group.message = value.message or group.message
        group.percentage = value.percentage or group.percentage
        progress_groups[key] = group
      end
      render_progress()
    end,
  })

  -- A stopped server may never send the final progress event.
  vim.api.nvim_create_autocmd("LspDetach", {
    group = group,
    callback = function(ev)
      local prefix = ev.data.client_id .. ":"
      for key in pairs(progress_groups) do
        if vim.startswith(key, prefix) then progress_groups[key] = nil end
      end
      render_progress()
    end,
  })
end

return M
