local root = assert(arg[1], "dotfiles root is required")
package.path = root .. "/nvim/lua/?.lua;" .. package.path

require("statusline").setup()

local function progress(value)
  vim.api.nvim_exec_autocmds("LspProgress", {
    data = {
      client_id = 1,
      params = { token = "test", value = value },
    },
  })
end

progress({ kind = "begin", title = "Indexing", message = "files", percentage = 10 })
progress({ kind = "report", message = vim.NIL, percentage = vim.NIL })
progress({ kind = "end" })
