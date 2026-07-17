local root = assert(arg[1], "dotfiles root is required")
package.path = root .. "/nvim/lua/?.lua;" .. package.path

local picker_win
vim.g.dotfiles_lazy = { fzf = function() end }
package.loaded["fzf-lua"] = {
  lsp_definitions = function()
    picker_win = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
      relative = "editor",
      row = 0,
      col = 0,
      width = 20,
      height = 5,
      style = "minimal",
    })
  end,
}

local get_clients = vim.lsp.get_clients
local buf_request_all = vim.lsp.buf_request_all
vim.lsp.get_clients = function()
  return { { offset_encoding = "utf-16" } }
end
vim.lsp.buf_request_all = function(_, _, _, callback)
  callback({
    css_classes = {
      result = {
        { uri = "file:///first.css" },
        { uri = "file:///second.css" },
      },
    },
  })
end

require("keymaps")

local gd
for _, mapping in ipairs(vim.api.nvim_get_keymap("n")) do
  if mapping.lhs == "gd" then gd = mapping.callback end
end
assert(type(gd) == "function", "gd mapping was not found")

local source_win = vim.api.nvim_get_current_win()
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "button" })
gd()
vim.lsp.get_clients = get_clients
vim.lsp.buf_request_all = buf_request_all

assert(vim.api.nvim_win_is_valid(picker_win), "definition picker did not open")
assert(vim.api.nvim_get_current_win() == picker_win, "definition picker did not retain focus")
assert(vim.api.nvim_get_current_win() ~= source_win)

local checkout
for _, mapping in ipairs(vim.api.nvim_get_keymap("n")) do
  if mapping.desc == "Checkout branch" then checkout = mapping.callback end
end
assert(type(checkout) == "function", "checkout mapping was not found")

local picker_opts
package.loaded["fzf-lua"].git_branches = function(opts) picker_opts = opts end
local calls = {}
package.loaded["fzf-lua.actions"] = {
  git_switch = function() table.insert(calls, "switch") end,
}
local git = require("git")
git.can_checkout = function() return true end
git.refresh = function() table.insert(calls, "refresh") end

checkout()
assert(type(picker_opts.actions.enter) == "function", "checkout action was not configured")
picker_opts.actions.enter({ "main" }, {})
assert(vim.deep_equal(calls, { "switch", "refresh" }), "status did not refresh after branch checkout")
