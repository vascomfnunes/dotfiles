local config = require 'vasco.config'

return {
  'saghen/blink.cmp',
  lazy = false,
  version = 'v0.*',
  event = 'InsertEnter',

  dependencies = {
    'rafamadriz/friendly-snippets',
    { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    {
      'saghen/blink.compat',
      optional = true,
      opts = {},
      version = not vim.g.lazyvim_blink_main and '*',
    },
  },

  opts_extend = {
    'sources.completion.enabled_providers',
    'sources.compat',
    'sources.default',
  },

  opts = {
    keymap = {
      preset = 'default',
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-l>'] = { 'accept', 'fallback' },
    },

    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono', -- 'mono' for Nerd Font Mono, 'normal' for Nerd Font
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'dadbod', 'cmdline' },
      providers = {
        dadbod = {
          name = 'Dadbod',
          module = 'vim_dadbod_completion.blink',
        },
        lsp = {
          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
        },
      },
    },

    signature = { enabled = true },

    completion = {
      accept = {
        auto_brackets = { enabled = true },
      },

      menu = {
        border = config.border.style,
        draw = {
          treesitter = { 'lsp' },
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind' },
          },
        },
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        treesitter_highlighting = true,
        window = {
          min_width = 10,
          max_width = 60,
          max_height = 20,
          border = 'rounded',
          winblend = 0,
          winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
          scrollbar = true,
          direction_priority = {
            menu_north = { 'e', 'w', 'n', 's' },
            menu_south = { 'e', 'w', 's', 'n' },
          },
        },
      },

      ghost_text = {
        enabled = vim.g.ai_cmp,
      },
    },

    snippets = {
      expand = function(snippet)
        require('luasnip').lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction)
        require('luasnip').jump(direction)
      end,
    },
  },
}
