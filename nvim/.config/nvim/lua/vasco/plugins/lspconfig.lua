return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'folke/neoconf.nvim', cmd = 'Neoconf', config = false, dependencies = { 'nvim-lspconfig' } },
    {
      'folke/neodev.nvim',
      opts = {},
      config = function()
        require('neodev').setup {
          library = { plugins = { 'neotest' }, types = true },
        }
      end,
    },
    'mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
  },
  keys = {
    {
      'gd',
      function()
        vim.lsp.buf.definition()
      end,
      desc = 'Go to definition',
    },
    {
      'gD',
      function()
        vim.lsp.buf.declaration()
      end,
      desc = 'Go to declaration',
    },
    {
      '<leader>cd',
      function()
        vim.diagnostic.open_float()
      end,
      desc = 'Line diagnostics',
    },
    {
      '<leader>ca',
      function()
        -- vim.lsp.buf.code_action()
        require('tiny-code-action').code_action()
      end,
      desc = 'Actions',
    },
  },
  opts = {
    diagnostics = {
      underline = false,
      update_in_insert = false,
      virtual_text = false, -- handled by lsp_lines.nvim plugin
      -- virtual_text = {
      --   spacing = 4,
      --   source = 'if_many',
      --   prefix = '●',
      -- },
      severity_sort = true,
    },
    -- Enable this to enable the builtin LSP inlay hints
    -- Be aware that you also will need to properly configure your LSP server to
    -- provide the inlay hints.
    inlay_hints = {
      enabled = true,
    },
    -- Enable this to enable the builtin LSP code lenses
    -- Be aware that you also will need to properly configure your LSP server to
    -- provide the code lenses.
    codelens = {
      enabled = true,
    },
    -- add any global capabilities here
    capabilities = {},
    -- Automatically format on save
    autoformat = false,
    -- Enable this to show formatters used in a notification
    -- Useful for debugging formatter issues
    format_notify = false,
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
    -- LSP Server Settings
    servers = {
      html = { filetypes = { 'html', 'eruby' } },
      cssls = { filetypes = { 'css', 'scss' } },
      stylelint_lsp = { filetypes = { 'css', 'scss' } },
      eslint = {},
      standardrb = {},
      bashls = {},
      tailwindcss = {},
      stimulus_ls = {},
      markdown_oxide = {},

      lua_ls = {
        -- keys = {},
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            codeLens = {
              enable = true,
            },
            telemety = { enable = false },
            completion = {
              callSnippet = 'Replace',
            },
            doc = {
              privateName = { '^_' },
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = 'Disable',
              semicolon = 'Disable',
              arrayIndex = 'Disable',
            },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            validate = true,
            schemaStore = {
              enable = true,
            },
          },
        },
      },
      jsonls = {
        settings = {
          json = {
            validate = true,
            schemaStore = {
              enable = true,
            },
          },
        },
      },
    },
    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    setup = {
      -- example to setup with typescript.nvim
      -- tsserver = function(_, opts)
      --   require("typescript").setup({ server = opts })
      --   return true
      -- end,
      -- Specify * to use this function as a fallback for any server
      -- ["*"] = function(server, opts) end,
    },
  },

  config = function(_, opts)
    local icons = require 'vasco.utils.icons'
    local config = require 'vasco.config'
    local signs = { Error = icons.error, Warn = icons.warning, Hint = icons.hint, Info = icons.info }

    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = config.border.style })

    local servers = opts.servers
    local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    local capabilities = vim.tbl_deep_extend(
      'force',
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      opts.capabilities or {}
    )

    local function setup(server)
      local server_opts = vim.tbl_deep_extend('force', {
        capabilities = vim.deepcopy(capabilities),
      }, servers[server] or {})

      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup['*'] then
        if opts.setup['*'](server, server_opts) then
          return
        end
      end
      require('lspconfig')[server].setup(server_opts)
    end

    -- get all the servers that are available through mason-lspconfig
    local have_mason, mlsp = pcall(require, 'mason-lspconfig')
    local all_mslp_servers = {}
    if have_mason then
      -- https://github.com/neovim/nvim-lspconfig/pull/3232
      require('mason-lspconfig').setup_handlers {
        function(server_name)
          if server_name == 'tsserver' then
            server_name = 'ts_ls'
          end
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          require('lspconfig')[server_name].setup {

            capabilities = capabilities,
          }
        end,
      }

      all_mslp_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)
    end

    local ensure_installed = {}
    for server, server_opts in pairs(servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
        if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
          setup(server)
        else
          ensure_installed[#ensure_installed + 1] = server
        end
      end
    end

    if have_mason then
      mlsp.setup { ensure_installed = ensure_installed, handlers = { setup } }
    end
  end,
}
