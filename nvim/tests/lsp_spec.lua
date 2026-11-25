local root = assert(arg[1], "dotfiles root is required")
package.path = root .. "/nvim/lua/?.lua;" .. package.path

local lsp = require("lsp")
lsp.setup()

local buf = vim.api.nvim_create_buf(false, true)
local client_id = 42
local orig_get_client = vim.lsp.get_client_by_id
vim.lsp.get_client_by_id = function(id)
  if id == client_id then
    return {
      id = client_id,
      supports_method = function() return false end,
      server_capabilities = {
        signatureHelpProvider = { triggerCharacters = { "(" } },
      },
    }
  end
  return orig_get_client(id)
end

vim.api.nvim_exec_autocmds("LspAttach", {
  buffer = buf,
  data = { client_id = client_id },
})

local group_name = "DotfilesSignatureHelp" .. buf .. ":" .. client_id
local before = vim.api.nvim_get_autocmds({ group = group_name, event = "InsertCharPre" })
assert(#before == 1, "signature help autocmd was not registered on LspAttach")

vim.api.nvim_exec_autocmds("LspDetach", {
  buffer = buf,
  data = { client_id = client_id },
})

local ok, after = pcall(vim.api.nvim_get_autocmds, { group = group_name })
assert(not ok or #after == 0, "signature help augroup leaked after LspDetach")

vim.lsp.get_client_by_id = orig_get_client
vim.api.nvim_buf_delete(buf, { force = true })
