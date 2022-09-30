-- LSP

local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')

if not cmp_ok then
  return
end

local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')

if not lspconfig_ok then
  return
end

local util = require 'lspconfig/util'

-- Lsp on attach
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- Lsp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { 'markdown', 'plaintext' },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  },
}

capabilities.textDocument.codeAction = {
  dynamicRegistration = false,
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = {
        '',
        'quickfix',
        'refactor',
        'refactor.extract',
        'refactor.inline',
        'refactor.rewrite',
        'source',
        'source.organizeImports',
      },
    },
  },
}

capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

-- Lsp handlers
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

vim.diagnostic.config {
  float = {
    border = 'rounded',
  },
}

-- Diagnostic signs
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- diagnostics options
vim.diagnostic.config {
  underline = false,
  virtual_text = true,
  signs = true,
  severity_sort = true,
}

-- Lsp servers

local servers = {
  'bashls',
  'cssls',
  'cssmodules_ls',
  'dockerls',
  'graphql',
  'stylelint_lsp',
  'solargraph',
  'omnisharp',
}

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }
end

lspconfig.yamlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = require('vasco.lsp.servers.yaml').settings,
  flags = { debounce_text_changes = 150 },
}

lspconfig.sumneko_lua.setup {
  capabilities = capabilities,
  on_attach = function(client, _)
    client.server_capabilities.document_formatting = false
  end,
  settings = require('vasco.lsp.servers.sumneko').settings,
  flags = { debounce_text_changes = 150 },
}

lspconfig.eslint.setup {
  capabilities = capabilities,
  on_attach = require('vasco.lsp.servers.eslint').on_attach,
  settings = require('vasco.lsp.servers.eslint').settings,
  flags = { debounce_text_changes = 150 },
}

lspconfig.ltex.setup {
  capabilities = capabilities,
  flags = { debounce_text_changes = 150 },
  default_config = {
    ltex = {
      cmd = { os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/ltex-ls/ltex-ls/bin/ltex-ls' },
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
  on_attach = on_attach,
  settings = require('vasco.lsp.servers.jsonls').settings,
  flags = { debounce_text_changes = 150 },
}

lspconfig.tailwindcss.setup {
  -- capabilities = require('vasco.lsp.servers.tsserver').capabilities,
  -- filetypes = require('vasco.lsp.servers.tailwindcss').filetypes,
  -- init_options = require('vasco.lsp.servers.tailwindcss').init_options,
  -- on_attach = require('vasco.lsp.servers.tailwindcss').on_attach,
  settings = require('vasco.lsp.servers.tailwindcss').settings,
}

lspconfig.tsserver.setup {
  capabilities = capabilities,
  on_attach = require('vasco.lsp.servers.tsserver').on_attach,
  settings = require('vasco.lsp.servers.tsserver').settings,
  flags = { debounce_text_changes = 150 },
}

lspconfig.html.setup {
  on_attach = function(client, _)
    client.server_capabilities.document_formatting = false
  end,
  capabilities = capabilities,
  flags = { debounce_text_changes = 150 },
}

lspconfig.emmet_ls.setup {
  capabilities = capabilities,
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
  flags = { debounce_text_changes = 150 },
  init_options = {
    html = {
      options = {
        -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
        ['bem.enabled'] = true,
      },
    },
  },
}
