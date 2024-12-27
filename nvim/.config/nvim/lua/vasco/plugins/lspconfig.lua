return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'folke/neoconf.nvim', cmd = 'Neoconf', config = false, dependencies = { 'nvim-lspconfig' } },
    { 'folke/neodev.nvim', opts = { library = { plugins = { 'neotest', 'nvim-dap-ui' }, types = true } } },
    'mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'saghen/blink.cmp',
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
    capabilities = {},
    autoformat = true,
    format_notify = true,
    format = { formatting_options = nil, timeout_ms = 3000 },
    servers = {
      html = { filetypes = { 'html', 'eruby' } },
      cssls = { filetypes = { 'css', 'scss' } },
      stylelint_lsp = { filetypes = { 'css', 'scss' } },
      eslint = {},
      ts_ls = {},
      ruby_lsp = {
        mason = false,
        cmd = { vim.fn.expand '~/.rbenv/shims/ruby-lsp' },
        init_options = {
          formatter = 'standard',
          linters = { 'standard' },
        },
      },
      standardrb = {},
      bashls = {},
      tailwindcss = {},
      stimulus_ls = {},
      markdown_oxide = {},
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
      yamlls = { settings = { yaml = { validate = true, schemaStore = { enable = true } } } },
      jsonls = { settings = { json = { validate = true, schemaStore = { enable = true } } } },
    },
    setup = {},
  },
  config = function(_, opts)
    local lspconfig = require 'lspconfig'
    local icons = require 'vasco.utils.icons'
    local settings = require 'vasco.config'

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
          server_opts.capabilities = require('blink.cmp').get_lsp_capabilities(server_opts.capabilities)
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
