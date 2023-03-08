local M = {
  'VonHeikemen/lsp-zero.nvim',
}

M.dependencies = {
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
  'jose-elias-alvarez/null-ls.nvim',
  {
    'ray-x/lsp_signature.nvim',
    config = function()
      require('lsp_signature').setup {
        noice = true,
      }
    end,
  },

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
}

M.event = 'BufReadPost'

function M.config()
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'
  local mason_settings = require 'mason.settings'
  local lsp = require 'lsp-zero'
  local icons = require 'vasco.helpers.icons'

  require('luasnip.loaders.from_vscode').load { paths = '~/.config/nvim/snippets/' }
  require('luasnip.loaders.from_vscode').lazy_load()

  local has_words_before = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    return (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or ''):sub(cursor[2], cursor[2]):match '%s'
  end

  lsp.set_preferences {
    suggest_lsp_servers = true,
    setup_servers_on_start = true,
    set_lsp_keymaps = false,
    configure_diagnostics = true,
    cmp_capabilities = true,
    manage_nvim_cmp = true,
    call_servers = 'local',
    sign_icons = {
      error = icons.error,
      warn = icons.warning,
      hint = icons.hint,
      info = icons.info,
    },
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
    'rust_analyzer',
    'tailwindcss',
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
    -- on_attach = function(client, bufnr)
    --   -- something here
    -- end,
  })

  lsp.configure('tailwindcss', {
    performance = {
      trigger_debounce_time = 500,
      throttle = 550,
      fetching_timeout = 80,
    },
    on_attach = function(client, bufnr)
      -- something here
      require('tailwind-highlight').setup(client, bufnr, {
        single_column = false,
        mode = 'background',
        debounce = 200,
      })
    end,
  })

  lsp.nvim_workspace()
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
    window = {
      completion = {
        border = 'rounded',
        winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
      },
      documentation = {
        border = 'rounded',
        winhighlight = 'FloatBorder:FloatBorder',
      },
    },
    formatting = {
      format = require('lspkind').cmp_format {
        mode = 'symbol_text',
        maxwidth = 100, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

        -- The function below will be called before any actual modifications from lspkind
        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        before = function(_, vim_item)
          return vim_item
        end,
      },
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
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })

  vim.diagnostic.config {
    float = {
      border = 'rounded',
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
      border = 'rounded',
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
    'yamlfmt',
    'rustfmt',
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
  table.insert(sources, null_ls.builtins.diagnostics.yamllint)
  table.insert(sources, null_ls.builtins.formatting.yamlfmt)
  table.insert(sources, null_ls.builtins.diagnostics.stylelint) -- npm install -g stylelint stylelint-config-standard stylelint-config-sass-guidelines stylelint-selector-bem-pattern postcss-scss
  table.insert(sources, null_ls.builtins.formatting.stylelint)
  table.insert(sources, null_ls.builtins.formatting.shfmt)
  table.insert(sources, null_ls.builtins.formatting.stylua)
  table.insert(sources, null_ls.builtins.formatting.prettier)
  table.insert(sources, null_ls.builtins.formatting.erb_format)

  null_ls.setup { sources = sources }
end

return M
