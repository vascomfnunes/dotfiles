local M = {}

local directions = {
  left = { key = "h", opposite = "l", tmux = "-L", axis = "vertical" },
  down = { key = "j", opposite = "k", tmux = "-D", axis = "horizontal" },
  up = { key = "k", opposite = "j", tmux = "-U", axis = "horizontal" },
  right = { key = "l", opposite = "h", tmux = "-R", axis = "vertical" },
}

local function tmux(command, direction, amount)
  if not vim.env.TMUX then return false end
  local args = { "tmux", command, direction.tmux }
  if amount then vim.list_extend(args, { tostring(amount) }) end
  vim.system(args, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        local message = vim.trim(result.stderr or "")
        vim.notify(message ~= "" and message or "tmux command failed", vim.log.levels.WARN)
      end)
    end
  end)
  return true
end

local function has_window(key)
  return vim.fn.winnr(key) ~= vim.fn.winnr()
end

function M.move(name)
  local direction = directions[name]
  local current = vim.api.nvim_get_current_win()
  vim.cmd.wincmd(direction.key)
  if vim.api.nvim_get_current_win() == current then
    tmux("select-pane", direction)
  end
end

function M.resize(name)
  local direction = directions[name]
  local amount = vim.v.count1 * 3
  local has_forward = has_window(direction.key)
  local has_backward = has_window(direction.opposite)

  -- No split exists on this axis, so resize the containing tmux pane.
  if not has_forward and not has_backward and tmux("resize-pane", direction, amount) then return end

  local at_end = not has_forward and has_backward
  local grow
  if name == "right" or name == "down" then
    grow = not at_end
  else
    grow = at_end
  end
  local command = direction.axis == "vertical" and "vertical resize " or "resize "
  vim.cmd(command .. (grow and "+" or "-") .. amount)
end

return M
