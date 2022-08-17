local M = {}

local kitty_directions = {
  h = 'left',
  j = 'bottom',
  k = 'top',
  l = 'right',
}

M.navigate = function(direction)
  local pos = vim.api.nvim_win_get_number(0)
  vim.api.nvim_command('wincmd ' .. direction)
  if pos == vim.api.nvim_win_get_number(0) then
    vim.api.nvim_command('silent !kitty @ kitten neighboring_window.py ' .. kitty_directions[direction])
  end
end

return M
