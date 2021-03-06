local lsp = require 'lspconfig'
local remap = vim.api.nvim_set_keymap
local saga = require 'lspsaga'

-- Auto completion configuration
require'compe'.setup {
  enabled = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  allow_prefix_unmatch = false,

  source = {path = true, buffer = true, ultisnips = true, nvim_lsp = true}
}

remap('i', '<c-space>', 'compe#complete()', {expr = true, silent = true})
remap('i', '<cr>', "compe#confirm(lexima#expand('<LT>CR>', 'i'))", {expr = true, silent = true})
remap('i', '<c-e>', "compe#close('<c-e>')", {expr = true, silent = true})

-- Saga configuration
saga.init_lsp_saga{
  use_saga_diagnostic_sign = true
}

remap('n', '[e', ':LspSagaDiagJumpPrev<cr>', {silent = true})
remap('n', ']e', ':LspSagaDiagJumpNext<cr>', {silent = true})

-- Attack lsp client
local on_attach = function(client)
  print("'" .. client.name .. "' language server started");

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

  remap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', {})
  remap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {})
  remap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {})
  remap('n', 'cd', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', {})
  remap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', {})
end

local default_lsp_config = {on_attach = on_attach}

local servers = {
  bashls = {},
  vimls = {},
  dockerls = {},
  jsonls = {},
  tsserver = {},
  html = {},
  cssls = {
    cmd = {'css-languageserver', '--stdio'},
    capabilities = {textDocument = {completion = {completionItem = {snippetSupport = true}}}}
  },
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
      'ruby',
      'eruby',
      'vue',
      'markdown',
      'sh'
    },
    init_options = {
      linters = {
        shellcheck = {
          sourceName = "shellcheck",
          command = "shellcheck",
          debounce = 100,
          args = {"--format=gcc", "-"},
          offsetLine = 0,
          offsetColumn = 0,
          formatLines = 1,
          formatPattern = {
            "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
            {line = 1, column = 2, message = 4, security = 3}
          },
          securities = {error = "error", warning = "warning"}
        },
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
        scsslint = {
          command = 'scss-lint',
          rootPatterns = {'.git'},
          args = {'-f', 'Default', '%file', '-c', '/Users/vasco.nunes/.scss-lint.yml'},
          formatLines = 1,
          debounce = 100,
          formatPattern = {"^[^:]+:(\\d+) (.*)$", {line = 1, message = 2}},
          sourceName = 'scss-lint',
          securities = {[2] = 'error', [1] = 'warning'}
        },
        rails_best_practices = {
          command = 'rails_best_practices',
          args = {'--without-color', '%file'},
          formatLines = 2,
          debounce = 100,
          formatPattern = {"^[^*rb](\\d) - (.*)$", {line = 1, message = 2}},
          sourceName = 'rails_best_practices'
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
        },
        -- writegood = {
        --   command = 'write-good',
        --   args = { '--text=%text' },
        --   offsetLine = 0,
        --   offsetColumn = 1,
        --   sourceName = 'write-good',
        --   formatLines = 1,
        --   formatPattern = {'(.*)\\s+on\\s+line\\s+(\\d+)\\s+at\\s+column\\s+(\\d+)\\s*$',
        --     {
        --       line = 2,
        --       column = 3,
        --       message = 1
        --     }
        --   }
        -- },
        erblint = {
          command = 'erblint',
          debounce = 200,
          args = {'%file'},
          sourceName = 'erblint',
          formatLines = 3,
          formatPattern = {'^\\n(.*)\\nIn file:.*:(\\d)+$', {line = 2, column = -1, message = 1}}
        },
        reek = {
          command = 'reek',
          debounce = 100,
          args = {'-s', '%file'},
          sourceName = 'reek',
          formatLines = 1,
          formatPattern = {'^[^:]+:(\\d+): (.*)$', {line = 1, message = 2}}
        }
        -- languagetool = {
        --   command = 'languagetool',
        --   offsetLine = 0,
        --   offsetColumn = 0,
        --   debounce = 200,
        --   args = {'-'},
        --   sourceName = 'languagetool',
        --   formatLines = 2,
        --   formatPattern = {'^\\d+?\\.\\)\\s+Line\\s+(\\d+),\\s+column\\s+(\\d+),\\s+([^\\n]+)\nMessage:\\s+(.*)$', {line = 1, column = 2, message = {4,3}}}
        -- }
      },
      filetypes = {
        javascript = 'eslint',
        javascriptreact = 'eslint',
        typescript = 'eslint',
        typescriptreact = 'eslint',
        markdown = {'markdownlint'},
        vue = 'prettier',
        ruby = {'reek', 'rails_best_practices'},
        scss = 'scsslint',
        sh = "shellcheck",
        eruby = "erblint"
      },
      formatters = {
        prettierEslint = {command = 'prettier-eslint', args = {'--stdin'}, rootPatterns = {'.git'}},
        eslint = {command = 'eslint', args = {'--stdin', '--fix'}, rootPatterns = {'.git'}},
        prettier = {command = 'prettier', args = {'--stdin-filepath', '%file'}},
        luaformat = {command = 'lua-format', args = {'%file', '-i'}, doesWriteToFile = true},
        erblint = {command = 'erblint', args = {'%file', '-a'}, doesWriteToFile = true}
      },
      formatFiletypes = {
        javascript = 'eslint',
        javascriptreact = 'eslint',
        json = 'prettier',
        typescript = 'prettierEslint',
        typescriptreact = 'prettierEslint',
        markdown = 'prettier',
        scss = 'prettier',
        css = 'prettier',
        html = 'prettier',
        lua = 'luaformat',
        yaml = 'prettier',
        vue = 'prettier',
        eruby = 'erblint'
      }
    }
  },

  solargraph = {settings = {solargraph = {diagnostics = true, formatting = true}}},

  yamlls = {settings = {yaml = {format = {enable = true, singleQuote = true}, validate = true}}},

  sumneko_lua = {
    cmd = {
      "/Users/vasco.nunes/bin/lua-language-server-repo/bin/macOS/lua-language-server",
      "-E",
      "/Users/vasco.nunes/bin/lua-language-server-repo/main.lua"
    },
    settings = {
      Lua = {
        runtime = {version = "LuaJIT", path = vim.split(package.path, ';')},
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
  underline = false,
  virtual_text = {spacing = 1, prefix = '??? '},
  update_in_insert = true
})
