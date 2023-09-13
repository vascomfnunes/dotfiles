local config = require 'vasco.config'

return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  event = 'VeryLazy',
  dependencies = {
    -- Tags
    {
      'weilbith/nvim-lsp-smag',
      config = function()
        vim.g.lsp_smag_fallback_tags = true
      end,
    },

    -- LSP Support
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',

    -- Autocompletion
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-cmdline',
    'L3MON4D3/LuaSnip',
    'jose-elias-alvarez/null-ls.nvim',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'onsails/lspkind.nvim',

    {
      'ray-x/lsp_signature.nvim',
      event = 'VeryLazy',
      opts = { noice = true },
      config = function(_, opts)
        require('lsp_signature').setup(opts)
      end,
    },

    -- Snippets
    { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
    'honza/vim-snippets',
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local cmp = require 'cmp'
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'
    local luasnip = require 'luasnip'
    local mason_settings = require 'mason.settings'
    local lsp = require('lsp-zero').preset {}
    local icons = require 'vasco.helpers.icons'

    require('luasnip.loaders.from_vscode').load { paths = '~/.config/nvim/snippets/' }
    require('luasnip.loaders.from_vscode').lazy_load()

    local has_words_before = function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      return (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or '')
        :sub(cursor[2], cursor[2])
        :match '%s'
    end

    lsp.set_preferences {
      setup_servers_on_start = true,
      set_lsp_keymaps = false,
      configure_diagnostics = true,
      manage_nvim_cmp = true,
      call_servers = 'local',
    }

    lsp.set_sign_icons {
      error = icons.error,
      warn = icons.warning,
      hint = icons.hint,
      info = icons.info,
    }

    local servers = {
      solargraph = {},
      tsserver = {},
      eslint = {},
      bashls = {},
      emmet_ls = {},
      yamlls = {},
      jsonls = {},
      marksman = {},
      dockerls = {},
      docker_compose_language_service = {},
      html = {},
      cssls = {},
      lua_ls = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
          telemetry = { enable = false },
          workspace = { checkThirdParty = false },
        },
      },
    }

    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

    lsp.nvim_workspace {}

    lsp.setup()

    -- cmp config
    cmp.setup {
      sources = cmp.config.sources {
        { name = 'path' },
        { name = 'nvim_lsp', keyword_length = 3, group_index = 1, max_item_count = 30 },
        { name = 'luasnip' },
        { name = 'nvim_lua' },
        { name = 'buffer', keyword_length = 3 },
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-q>'] = cmp.mapping.abort(),
        ['<C-l>'] = cmp.mapping.confirm { select = true },

        ['<C-j>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-k>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      completion = {
        completeopt = 'menu,menuone',
      },
      window = {
        completion = {
          border = config.border_style,
          winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
          col_offset = -3,
          side_padding = 0,
        },
        documentation = {
          border = config.border_style,
          winhighlight = 'FloatBorder:FloatBorder',
        },
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          local kind =
            require('lspkind').cmp_format { mode = 'symbol_text', preset = 'default', maxwidth = 50 }(entry, vim_item)
          local strings = vim.split(kind.kind, '%s', { trimempty = true })
          kind.kind = ' ' .. (strings[1] or '') .. ' '
          kind.menu = '    (' .. (strings[2] or '') .. ')'

          return kind
        end,
      },
    }

    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })

    -- Lsp handlers
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = config.border_style })

    vim.diagnostic.config {
      float = {
        border = config.border_style,
      },
    }

    -- diagnostics options
    vim.diagnostic.config {
      underline = false,
      virtual_text = true,
      signs = true,
      severity_sort = true,
    }

    -- Mason setup

    mason_settings.set {
      ui = {
        border = config.border_style,
        icons = {
          package_installed = icons.check,
          package_pending = icons.cog,
          package_uninstalled = icons.error,
        },
      },
    }

    local mason_tools = {
      'prettier',
      'stylua',
      'stylelint',
      'shellcheck',
      'shfmt',
      'gitlint',
      'jsonlint',
      'chrome-debug-adapter',
      'node-debug2-adapter',
    }

    local function mason_check()
      local mr = require 'mason-registry'
      for _, tool in ipairs(mason_tools) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end

    require('mason').setup()

    mason_check()

    require('mason-lspconfig').setup {
      automatic_installation = true,
      ensure_installed = vim.tbl_keys(servers),
    }

    require('mason-lspconfig').setup_handlers {
      function(server_name)
        local normal_capabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = cmp_nvim_lsp.default_capabilities(normal_capabilities)

        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          settings = servers[server_name],
        }
      end,
    }

    -- null-ls
    local null_ls = require 'null-ls'

    local sources = {}

    -- bellow clients require manual installation
    -- Use Mason or directly :NullLsInstall to install packages
    table.insert(sources, null_ls.builtins.code_actions.shellcheck)
    table.insert(sources, null_ls.builtins.diagnostics.markdownlint)
    table.insert(sources, null_ls.builtins.diagnostics.gitlint)
    table.insert(sources, null_ls.builtins.formatting.markdownlint)
    table.insert(sources, null_ls.builtins.diagnostics.stylelint) -- npm install -g stylelint stylelint-config-standard stylelint-config-sass-guidelines stylelint-selector-bem-pattern postcss-scss
    table.insert(sources, null_ls.builtins.formatting.shfmt)
    table.insert(sources, null_ls.builtins.formatting.stylua)
    table.insert(
      sources,
      null_ls.builtins.formatting.prettier.with {
        filetypes = {
          'javascript',
          'typescript',
          'css',
          'scss',
          'html',
          'json',
          'yaml',
          'markdown',
          'md',
          'txt',
        },
      }
    )
    table.insert(sources, null_ls.builtins.formatting.erb_format)

    null_ls.setup { sources = sources }
  end,
}
