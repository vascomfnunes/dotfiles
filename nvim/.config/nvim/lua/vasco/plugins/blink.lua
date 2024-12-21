local config = require 'vasco.config'

return {
  'saghen/blink.cmp',
  lazy = false,
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
  version = 'v0.*',
  event = 'InsertEnter',
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
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'dadbod', 'cmdline' },
      providers = {
        dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        lsp = {
          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
        },
      },
    },

    -- experimental signature help support
    signature = { enabled = true },

    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        border = config.border.style,
        draw = {
          treesitter = { 'lsp' },
          columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind' } },
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
          -- Note that the gutter will be disabled when border ~= 'none'
          scrollbar = true,
          -- Which directions to show the documentation window,
          -- for each of the possible menu window directions,
          -- falling back to the next direction when there's not enough space
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
