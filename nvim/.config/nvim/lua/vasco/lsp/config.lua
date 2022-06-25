-- LSP
--

-- Lsp on attach
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- Lsp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')

if not status_ok then
  return
end

capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

-- Lsp handlers
local handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
  }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
  }),
}

-- Diagnostic signs
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Lsp servers
--

require('nvim-lsp-installer').setup {
  automatic_installation = true,
}

local lspconfig = require 'lspconfig'

lspconfig.sumneko_lua.setup {
  handlers = handlers,
  on_attach = on_attach,
  settings = require('vasco.lsp.servers.sumneko').settings,
}

lspconfig.eslint.setup {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = require('vasco.lsp.servers.eslint').on_attach,
  settings = require('vasco.lsp.servers.eslint').settings,
}

lspconfig.jsonls.setup {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = on_attach,
  settings = require('vasco.lsp.servers.jsonls').settings,
}

lspconfig.tailwindcss.setup {
  capabilities = require('vasco.lsp.servers.tsserver').capabilities,
  filetypes = require('vasco.lsp.servers.tailwindcss').filetypes,
  init_options = require('vasco.lsp.servers.tailwindcss').init_options,
  on_attach = require('vasco.lsp.servers.tailwindcss').on_attach,
  settings = require('vasco.lsp.servers.tailwindcss').settings,
  handlers = handlers,
}

lspconfig.tsserver.setup {
  capabilities = require('vasco.lsp.servers.tsserver').capabilities,
  on_attach = require('vasco.lsp.servers.tsserver').on_attach,
  handlers = handlers,
}

lspconfig.html.setup {
  on_attach = function(client, bufnr)
    on_attach, client.resolved_capabilities.document_formatting = false
  end,
  capabilities = capabilities,
  handlers = handlers,
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
  'eslint',
  'graphql',
  'tailwindcss',
}

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
  }
end
