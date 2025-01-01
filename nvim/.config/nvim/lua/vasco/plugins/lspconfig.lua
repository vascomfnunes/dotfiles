return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'folke/neoconf.nvim', cmd = 'Neoconf', config = false, dependencies = { 'nvim-lspconfig' } },
    { 'folke/neodev.nvim', opts = { library = { plugins = { 'neotest', 'nvim-dap-ui' }, types = true } } },
    'mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
  },
  keys = {
    { 'gd', vim.lsp.buf.definition, desc = 'Go to definition' },
    { 'gD', vim.lsp.buf.declaration, desc = 'Go to declaration' },
    { 'gr', vim.lsp.buf.references, desc = 'Go to references' },
    { 'gi', vim.lsp.buf.implementation, desc = 'Go to implementation' },
    { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename' },
    { 'K', vim.lsp.buf.hover, desc = 'Hover Documentation' },
    { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code Actions' },
  },
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = { spacing = 4, source = 'if_many', prefix = '●' },
      severity_sort = true,
    },
    inlay_hints = { enabled = true },
    codelens = { enabled = true, refresh_interval = 200 },
    autoformat = true,
    format_notify = true,
    format = { formatting_options = nil, timeout_ms = 3000 },
    servers = {
      -- Web Development
      html = { filetypes = { 'html', 'eruby' } },
      cssls = { filetypes = { 'css', 'scss' } },
      stylelint_lsp = { filetypes = { 'css', 'scss' } },
      eslint = {},
      ts_ls = {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
        },
      },
      tailwindcss = {},
      stimulus_ls = {},

      -- Ruby
      ruby_lsp = {
        mason = false,
        -- Safely resolve ruby-lsp path with fallback
        cmd = function()
          local ruby_lsp = vim.fn.exepath 'ruby-lsp'
          if ruby_lsp then
            return { ruby_lsp }
          end
          local rbenv_lsp = vim.fn.expand '~/.rbenv/shims/ruby-lsp'
          if vim.fn.filereadable(rbenv_lsp) == 1 then
            return { rbenv_lsp }
          end
          vim.notify('ruby-lsp not found', vim.log.levels.WARN)
          return nil
        end,
        init_options = {
          formatter = 'standard',
          linters = { 'standard' },
        },
      },
      standardrb = {},

      -- Shell
      bashls = {},

      -- Documentation
      markdown_oxide = {},

      -- Lua
      lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            codeLens = { enable = true },
            telemetry = { enable = false },
            completion = { callSnippet = 'Replace' },
            doc = { privateName = { '^_' } },
            hint = {
              enable = true,
              setType = true,
              paramType = true,
              paramName = 'Literal',
              semicolon = 'Disable',
              arrayIndex = 'Enable',
            },
            diagnostics = { globals = { 'vim' } },
          },
        },
      },

      -- Configuration Files
      yamlls = { settings = { yaml = { validate = true, schemaStore = { enable = true } } } },
      jsonls = { settings = { json = { validate = true, schemaStore = { enable = true } } } },
    },
    setup = {},
  },
  config = function(_, opts)
    local lspconfig = require 'lspconfig'
    local icons = require 'vasco.utils.icons'
    local settings = require 'vasco.config'

    -- Initialize capabilities
    local capabilities = vim.tbl_deep_extend(
      'force',
      {},
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities(),
      opts.capabilities or {}
    )
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    opts.capabilities = capabilities

    local function setup_diagnostic_signs()
      local signs = { Error = icons.error, Warn = icons.warning, Hint = icons.hint, Info = icons.info }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end

    local function setup_mason()
      local have_mason, mlsp = pcall(require, 'mason-lspconfig')
      if not have_mason then
        return
      end

      local ensure_installed = {}
      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          table.insert(ensure_installed, server)
        end
      end

      mlsp.setup { ensure_installed = ensure_installed }
      mlsp.setup_handlers {
        function(server_name)
          local server_opts = opts.servers[server_name] or {}
          lspconfig[server_name].setup(server_opts)
        end,
      }
    end

    setup_diagnostic_signs()
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = settings.border.style })
    setup_mason()
  end,
}
