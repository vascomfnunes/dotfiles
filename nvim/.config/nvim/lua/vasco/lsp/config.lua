-- LSP

local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')

if not cmp_ok then
  return
end

local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')

if not lspconfig_ok then
  return
end

local mason_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')

if not mason_ok then
  return
end

local util = require 'lspconfig/util'

-- Lsp on attach
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- Lsp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

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

local servers = {
  'bashls',
  'cssls',
  'cssmodules_ls',
  'dockerls',
  'emmet_ls',
  'graphql',
  'yamlls',
  'stylelint_lsp',
  'sumneko_lua',
  'html',
  'solargraph',
  'jsonls',
  'eslint',
  'tsserver',
  'omnisharp',
  'zk'
  -- 'tailwindcss'
}

mason_lspconfig.setup {
  ensure_installed = servers,
  -- automatic_installation = true,
}

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
  }
end

lspconfig.sumneko_lua.setup {
  handlers = handlers,
  on_attach = function(client, _)
    client.resolved_capabilities.document_formatting = false
  end,
  settings = require('vasco.lsp.servers.sumneko').settings,
}

lspconfig.eslint.setup {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = require('vasco.lsp.servers.eslint').on_attach,
  settings = require('vasco.lsp.servers.eslint').settings,
}

-- This one is not working at the moment through Mason, so requires to be installed with homebrew:
-- e.g. 'brew install ltex-ls'
lspconfig.ltex.setup {
  capabilities = capabilities,
  default_config = {
    ltex = {
      cmd = { '/homebrew/Cellar/ltex-ls/15.2.0/bin/ltex-ls' },
      filetypes = { 'tex', 'bib', 'md' },
      root_dir = function(filename)
        return util.path.dirname(filename)
      end,
      settings = {
        ltex = {
          enabled = { 'latex', 'tex', 'bib', 'md' },
        },
      },
    },
  },
}

lspconfig.jsonls.setup {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = on_attach,
  settings = require('vasco.lsp.servers.jsonls').settings,
}

-- lspconfig.tailwindcss.setup {
--   capabilities = require('vasco.lsp.servers.tsserver').capabilities,
--   filetypes = require('vasco.lsp.servers.tailwindcss').filetypes,
--   init_options = require('vasco.lsp.servers.tailwindcss').init_options,
--   on_attach = require('vasco.lsp.servers.tailwindcss').on_attach,
--   settings = require('vasco.lsp.servers.tailwindcss').settings,
--   handlers = handlers,
-- }

lspconfig.tsserver.setup {
  capabilities = require('vasco.lsp.servers.tsserver').capabilities,
  on_attach = require('vasco.lsp.servers.tsserver').on_attach,
  handlers = handlers,
  settings = require('vasco.lsp.servers.tsserver').settings,
}

lspconfig.html.setup {
  on_attach = function(client, _)
    client.resolved_capabilities.document_formatting = false
  end,
  capabilities = capabilities,
  handlers = handlers,
}

lspconfig.emmet_ls.setup {
  capabilities = capabilities,
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
  init_options = {
    html = {
      options = {
        -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
        ['bem.enabled'] = true,
      },
    },
  },
}
