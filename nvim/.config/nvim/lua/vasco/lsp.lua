-- LSP

local lsp_setup, status_ok = pcall(require, 'lsp-setup')

if not status_ok then
  return
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local settings = {
  on_attach = function(client, bufnr)
    -- Enable for formatting on save:
    -- require('lsp-setup.utils').format_on_save(client)
  end,
  capabilities = capabilities,
  default_mappings = false,
  mappings = {},
  servers = {
    bashls = {},
    cssls = {},
    cssmodules_ls = {},
    dockerls = {},
    emmet_ls = {},
    graphql = {},
    -- intelephense = {},
    -- pylsp = {},
    html = {},
    omnisharp = {},
    solargraph = {},
    stylelint_lsp = {},
    ltex = {},
    -- tailwindcss = {},
    yamlls = {},
    eslint = {},
    -- zk = {},
    jsonls = {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    },
    tsserver = {},
    -- gopls = {
    --   settings = {
    --     golsp = {
    --       gofumpt = true,
    --       staticcheck = true,
    --       useplaceholders = true,
    --       codelenses = {
    --         gc_details = true,
    --       },
    --     },
    --   },
    -- },
    sumneko_lua = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = {
              [vim.fn.expand '$VIMRUNTIME/lua'] = true,
              [vim.fn.expand '$VIMRUNTIME/lua/vim/lsp'] = true,
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    },
    -- rust_analyzer = {
    --   settings = {
    --     ['rust-analyzer'] = {
    --       cargo = {
    --         loadOutDirsFromCheck = true,
    --       },
    --       procMacro = {
    --         enable = true,
    --       },
    --     },
    --   },
    -- },
  },
}

require('lsp-setup').setup(settings)

require('mason').setup {
  ui = {
    border = 'rounded',
    icons = {
      package_installed = ' ',
      package_pending = ' ',
      package_uninstalled = ' ',
    },
  },
}

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
