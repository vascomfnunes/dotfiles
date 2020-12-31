local lsp = require 'lspconfig'
local completion = require 'completion'
local remap = vim.api.nvim_set_keymap

local on_attach = function(client)
  print("'" .. client.name .. "' language server started");

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

  completion.on_attach(client)
  remap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
  remap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
  remap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})
  remap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', {noremap = true, silent = true})
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
  vim.g.completion_matching_strategy_list = {"exact", "substring", "fuzzy"}
  vim.g.completion_enable_snippet = "UltiSnips"
end

local default_lsp_config = {on_attach = on_attach}

local servers = {
  bashls = {},
  vimls = {},
  dockerls = {},
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
      'yaml',
      'lua',
      'vue',
      'markdown'
    },
    init_options = {
      linters = {
        eslint = {
          command = 'eslint',
          rootPatterns = {'.git'},
          debounce = 100,
          args = {'--stdin', '--stdin-filename', '%filepath', '--format', 'json'},
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
          securities = {[2] = 'error', [1] = 'warning'}
        },
        markdownlint = {
          command = 'markdownlint',
          rootPatterns = {'.git'},
          isStderr = true,
          debounce = 100,
          args = {'--stdin'},
          offsetLine = 0,
          offsetColumn = 0,
          sourceName = 'markdownlint',
          securities = {undefined = 'hint'},
          formatLines = 1,
          formatPattern = {'^.*:(\\d+)\\s+(.*)$', {line = 1, column = -1, message = 2}}
        }
      },
      filetypes = {
        javascript = 'eslint',
        javascriptreact = 'eslint',
        typescript = 'eslint',
        typescriptreact = 'eslint',
        markdown = 'markdownlint',
        vue = 'prettier'
      },
      formatters = {
        prettierEslint = {command = 'prettier-eslint', args = {'--stdin'}, rootPatterns = {'.git'}},
        prettier = {command = 'prettier', args = {'--stdin-filepath', '%filename'}},
        luaformat = {command = 'lua-format', args = {'%filename', '-i'}, doesWriteToFile = true}
      },
      formatFiletypes = {
        javascript = 'prettierEslint',
        javascriptreact = 'prettierEslint',
        json = 'prettier',
        typescript = 'prettierEslint',
        typescriptreact = 'prettierEslint',
        markdown = 'prettier',
        scss = 'prettier',
        css = 'prettier',
        html = 'prettier',
        lua = 'luaformat',
        yaml = 'prettier',
        vue = 'prettier'
      }
    }
  },

  solargraph = {settings = {solargraph = {diagnostics = true, formatting = true}}},

  yamlls = {settings = {yaml = {format = {enable = true, singleQuote = true}, validate = true}}},

  sumneko_lua = {
    cmd = {'/home/vasco.nunes/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/bin/Linux/lua-language-server'},
    settings = {
      Lua = {
        diagnostics = {enable = true, globals = {"vim", "use"}},
        workspace = {library = {['$VIMRUNTIME/lua'] = true}}
      }
    }
  },

  clangd = {
    cmd = {"clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy", "--header-insertion=iwyu"}
  }
}

for server, config in pairs(servers) do
  lsp[server].setup(vim.tbl_deep_extend("force", default_lsp_config, config))
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = true,
  update_in_insert = false
})
