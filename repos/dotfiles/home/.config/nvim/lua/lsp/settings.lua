local lsp = require 'lspconfig'
local completion = require 'completion'

local function mapper(mode, key, result)
  vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua " .. result .. "<CR>", {noremap = true, silent = true})
end

local on_attach = function(client)
  print("'" .. client.name .. "' language server started" );

  if client.config.flags then client.config.flags.allow_incremental_sync = true end

  completion.on_attach(client)
  mapper('n', 'gd', 'vim.lsp.buf.definition()')
  mapper('n', 'gs', 'vim.lsp.buf.signature_help()')
  mapper('n', 'K', 'vim.lsp.buf.hover()')
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
  vim.g.completion_enable_snippet = "UltiSnips"
end

local default_lsp_config = {on_attach = on_attach}

local servers = {
  -- diagnosticls = diagnostics.options,
  bashls = {},
  vimls = {},
  dockerls = {},
  yamlls = {},
  jsonls = {},
  tsserver = {},
  html = {},
  cssls = {},
  diagnosticls = {
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'css',
      'scss',
      'html',
      'markdown',
    },
    init_options = {
      linters = {
        eslint = {
          command = 'eslint',
          rootPatterns = { '.git' },
          debounce = 100,
          args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
          sourceName = 'eslint',
          parseJson = {
            errorsRoot = '[0].messages',
            line = 'line',
            column = 'column',
            endLine = 'endLine',
            endColumn = 'endColumn',
            message = '[eslint] ${message} [${ruleId}]',
            security = 'severity'
          },
          securities = {
            [2] = 'error',
            [1] = 'warning'
          }
        },
        markdownlint = {
          command = 'markdownlint',
          rootPatterns = { '.git' },
          isStderr = true,
          debounce = 100,
          args = { '--stdin' },
          offsetLine = 0,
          offsetColumn = 0,
          sourceName = 'markdownlint',
          securities = {
            undefined = 'hint'
          },
          formatLines = 1,
          formatPattern = {
            '^.*:(\\d+)\\s+(.*)$',
            {
              line = 1,
              column = -1,
              message = 2,
            }
          }
        }
      },
      filetypes = {
        javascript = 'eslint',
        javascriptreact = 'eslint',
        typescript = 'eslint',
        typescriptreact = 'eslint',
        markdown = 'markdownlint'
      },
      formatters = {
        prettierEslint = {
          command = 'prettier-eslint',
          args = { '--stdin' },
          rootPatterns = { '.git' },
        },
        prettier = {
          command = 'prettier',
          args = { '--stdin-filepath', '%filename' }
        }
      },
      formatFiletypes = {
        javascript = 'prettierEslint',
        javascriptreact = 'prettierEslint',
        json = 'prettier',
        scss = 'prettier',
        typescript = 'prettierEslint',
        typescriptreact = 'prettierEslint',
        markdown = 'prettier',
        scss = 'prettier',
        css = 'prettier',
        html = 'prettier'
      }
    }
  },

  solargraph = {
    settings = {
      solargraph = {
        diagnostics = true,
        formatting = true,
      },
    },
  },

  yamlls = {
    settings = {
      yaml = {
        format = {
          enable = true,
          singleQuote = true,
        },
        validate = true}
      }
    },

    sumneko_lua = {
    cmd = {'/home/vasco.nunes/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/bin/Linux/lua-language-server'},
    settings = {
      Lua = {
        diagnostics = {
          globals = {'vim', 'use', 'imap', 'nmap', 'vmap', 'tmap', 'inoremap', 'nnoremap', 'vnoremap', 'tnoremap'}
        },
        workspace = {library = {['$VIMRUNTIME/lua'] = true}}
      }
    }
  }
}

for server, config in pairs(servers) do lsp[server].setup(vim.tbl_deep_extend("force", default_lsp_config, config)) end
