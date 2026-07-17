local M = {}

function M.head(output)
  for line in (output .. "\n"):gmatch("(.-)\n") do
    local value = line:match("^%*%s*(.-)%s*$")
    if value then
      local branch, status = value:match("^(%S+)%s*(.-)%s*$")
      if status == "[gone]" then return branch, "gone" end

      local ahead = status:match("ahead (%d+)")
      local behind = status:match("behind (%d+)")
      local parts = {}
      if behind then table.insert(parts, "↓" .. behind) end
      if ahead then table.insert(parts, "↑" .. ahead) end
      return branch, table.concat(parts, " ")
    end
  end
  return "", ""
end

function M.selected_branch(selected)
  if not selected[1] then return nil end
  local line = selected[1]:gsub("\27%[[0-9;]*m", "")
  return line:match("^%s*[%*+]?%s*[(]?([^%s)]+)")
end

function M.selected_commit(selected)
  if not selected[1] then return nil end
  local line = selected[1]:gsub("\27%[[0-9;]*m", "")
  return line:match("^%s*(%x+)")
end

return M
