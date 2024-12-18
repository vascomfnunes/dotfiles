return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'folke/neoconf.nvim', cmd = 'Neoconf', config = false, dependencies = { 'nvim-lspconfig' } },
    {
      'folke/neodev.nvim',
      opts = {
        library = {
          plugins = { 'neotest', 'nvim-dap-ui' },
          types = true,
        },
      },
    },
    'mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'saghen/blink.cmp',
    'netmute/ctags-lsp.nvim', -- install manually with `brew install netmute/tap/ctags-lsp`
  },
  keys = {
    { 'gd', vim.lsp.buf.definition, desc = 'Go to definition' },
    { 'gD', vim.lsp.buf.declaration, desc = 'Go to declaration' },
    { 'gr', vim.lsp.buf.references, desc = 'Go to references' },
    { 'gi', vim.lsp.buf.implementation, desc = 'Go to implementation' },
    { 'K', vim.lsp.buf.hover, desc = 'Hover Documentation' },
    { '<leader>cd', vim.diagnostic.open_float, desc = 'Line diagnostics' },
    { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code Actions' },
    { '<leader>rn', vim.lsp.buf.rename, desc = 'Rename' },
  },
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = 'if_many',
        prefix = '●',
      },
      severity_sort = true,
    },
    inlay_hints = {
      enabled = true,
    },
    codelens = {
      enabled = true,
      refresh_interval = 200,
    },
    capabilities = {},
    autoformat = true,
    format_notify = true,
    format = {
      formatting_options = nil,
      timeout_ms = 3000,
    },
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
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            validate = true,
            schemaStore = { enable = true },
          },
        },
      },
      jsonls = {
        settings = {
          json = {
            validate = true,
            schemaStore = { enable = true },
          },
        },
      },
    },
    setup = {},
  },

  config = function(_, opts)
    local lspconfig = require 'lspconfig'
    local icons = require 'vasco.utils.icons'
    local signs = { Error = icons.error, Warn = icons.warning, Hint = icons.hint, Info = icons.info }
    local settings = require 'vasco.config'

    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = settings.border.style })

    for server, config in pairs(opts.servers) do
      config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
      lspconfig[server].setup(config)
    end

    require('lspconfig').ctags_lsp.setup {}

    local have_mason, mlsp = pcall(require, 'mason-lspconfig')
    local ensure_installed = {}
    local servers = opts.servers

    for server, server_opts in pairs(servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        ensure_installed[#ensure_installed + 1] = server
      end
    end

    if have_mason then
      mlsp.setup { ensure_installed = ensure_installed, handlers = { setup } }
    end
  end,
}
