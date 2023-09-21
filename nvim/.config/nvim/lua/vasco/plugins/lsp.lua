local config = require 'vasco.config'

return {
  'neovim/nvim-lspconfig',
  lazy = false,
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'folke/neodev.nvim',
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'rafamadriz/friendly-snippets',
        'hrsh7th/cmp-cmdline',
        'onsails/lspkind.nvim',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
      },
      config = function()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        local icons = require 'vasco.helpers.icons'

        require('luasnip.loaders.from_vscode').load { paths = '~/.config/nvim/snippets/' }
        require('luasnip.loaders.from_vscode').lazy_load()

        luasnip.config.setup {}

        cmp.setup {
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
          sources = cmp.config.sources {
            { name = 'path' },
            { name = 'nvim_lsp', keyword_length = 3, group_index = 1, max_item_count = 30 },
            { name = 'luasnip' },
            { name = 'nvim_lua' },
            { name = 'buffer', keyword_length = 3 },
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
              local kind = require('lspkind').cmp_format { mode = 'symbol_text', preset = 'default', maxwidth = 50 }(
                entry,
                vim_item
              )
              local strings = vim.split(kind.kind, '%s', { trimempty = true })
              kind.kind = ' ' .. (strings[1] or '') .. ' '
              kind.menu = '    (' .. (strings[2] or '') .. ')'

              return kind
            end,
          },
        }

        local servers = {
          tsserver = {},
          html = { filetypes = { 'html', 'twig' } },
          cssls = { filetypes = { 'css', 'scss' } },
          solargraph = {},

          lua_ls = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        }

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        -- Ensure the servers above are installed
        local mason_lspconfig = require 'mason-lspconfig'

        mason_lspconfig.setup {
          ensure_installed = vim.tbl_keys(servers),
        }

        local mason_tools = {
          'prettierd',
          'stylua',
          'shfmt',
          'chrome-debug-adapter',
          'node-debug2-adapter',
        }

        local mr = require 'mason-registry'

        for _, tool in ipairs(mason_tools) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end

        local on_attach = function(_, bufnr) end

        -- Setup neovim lua configuration
        require('neodev').setup()

        mason_lspconfig.setup_handlers {
          function(server_name)
            require('lspconfig')[server_name].setup {
              capabilities = capabilities,
              on_attach = on_attach,
              settings = servers[server_name],
              filetypes = (servers[server_name] or {}).filetypes,
            }
          end,
        }

        require('mason.settings').set {
          ui = {
            border = config.border_style,
            icons = {
              package_installed = icons.check,
              package_pending = icons.cog,
              package_uninstalled = icons.error,
            },
          },
        }

        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = config.border_style })

        vim.diagnostic.config {
          float = {
            border = config.border_style,
          },
          underline = false,
          virtual_text = true,
          signs = true,
          severity_sort = true,
        }

        local signs = { Error = icons.error, Warn = icons.warning, Hint = icons.hint, Info = icons.info }
        for type, icon in pairs(signs) do
          local hl = 'DiagnosticSign' .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
      end,
    },
  },
}
