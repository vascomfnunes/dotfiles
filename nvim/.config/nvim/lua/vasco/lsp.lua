-- LSP
--

local status_ok, lsp_installer = pcall(require, 'nvim-lsp-installer')

if not status_ok then
  return
end

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'rounded',
})

require('nvim-lsp-installer').setup {
  automatic_installation = true,
}

local lspconfig = require 'lspconfig'

-- lspconfig.sumneko_lua.setup {
--   capabilities = capabilities,
--   settings = {
--     Lua = {
--       runtime = {
--         version = 'LuaJIT',
--         path = vim.split(package.path, ';'),
--       },
--       diagnostics = {
--         globals = { 'vim' },
--       },
--       workspace = {
--         library = vim.api.nvim_get_runtime_file('', true),
--       },
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
-- }

lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    on_attach,
    client.resolved_capabilities.document_formatting = false
  end,
  capabilities = capabilities,
}

lspconfig.html.setup {
  on_attach = function(client, bufnr)
    on_attach,
    client.resolved_capabilities.document_formatting = false
  end,
  capabilities = capabilities,
}

-- Other servers

local servers = {
  'cssls',
  'bashls',
  'cssmodules_ls',
  'dockerls',
  'emmet_ls',
  'eslint',
  'grammarly',
  'jsonls',
  'yamlls',
  'solargraph',
  'tailwindcss'
}

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

--
-- Diagnostic signs
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
