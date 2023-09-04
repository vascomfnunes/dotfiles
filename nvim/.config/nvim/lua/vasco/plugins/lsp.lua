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
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-cmdline',
        'onsails/lspkind.nvim',
      },
    },

    -- Snippets
    { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
    'honza/vim-snippets',
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local cmp = require 'cmp'
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

    lsp.ensure_installed {
      'tsserver',
      'eslint',
      'solargraph',
      'lua_ls',
      'bashls',
      'cssls',
      'emmet_ls',
      'html',
      'stylelint_lsp',
      'grammarly',
      'yamlls',
      'jsonls',
      'marksman',
      'cucumber_language_server',
      'dockerls',
      'docker_compose_language_service',
    }

    lsp.configure('jsonls', {
      flags = {
        debounce_text_changes = 150,
      },
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    lsp.configure('yamlls', {
      settings = {
        yaml = {
          schemas = require('schemastore').yaml.schemas(),
        },
      },
    })

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
      'shellcheck',
      'shfmt',
      'gitlint',
      'jsonlint',
      'chrome-debug-adapter',
      'node-debug2-adapter',
      'markdownlint',
      'yamllint',
      'stylelint',
      'jq',
      'rubocop'
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
    }
  end,
}
