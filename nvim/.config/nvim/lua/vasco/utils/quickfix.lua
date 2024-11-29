local cmd, fn = vim.cmd, vim.fn

local M = {}

-- check if a variable is not empty nor nil
local function is_not_empty(s)
  return s ~= nil and s ~= ''
end

-- toggle quickfixlist
M.toggle_qf = function()
  local qf_exists = false
  for _, win in ipairs(fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_exists = true
      break
    end
  end
  if qf_exists then
    cmd 'cclose'
  elseif is_not_empty(fn.getqflist()) then
    cmd 'copen'
  end
end

return M
