local config = require 'vasco.config'

return {
  'saghen/blink.cmp',
  lazy = false,
  version = 'v0.*',
  event = { 'InsertEnter', 'CmdlineEnter' },

  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      config = function()
        require('luasnip').setup()
      end,
    },
    'rafamadriz/friendly-snippets',
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
      ['<C-k>'] = {
        'select_prev',
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-k>', true, true, true), 'n', true)
        end,
      },
      ['<C-j>'] = {
        'select_next',
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-j>', true, true, true), 'n', true)
        end,
      },
      ['<C-l>'] = {
        'accept',
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-l>', true, true, true), 'n', true)
        end,
      },
    },

    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono',
    },

    sources = {
      -- Check for optional dependencies before enabling them
      default = (function()
        local sources = { 'lsp', 'path', 'snippets', 'buffer' }
        if pcall(require, 'vim_dadbod_completion') then
          table.insert(sources, 'dadbod')
        end
        if pcall(require, 'render-markdown') then
          table.insert(sources, 'markdown')
        end
        return sources
      end)(),
      providers = {
        markdown = { name = 'RenderMarkdown', module = 'render-markdown.integ.blink', fallbacks = { 'lsp' } },
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
          winhighlight = table.concat({
            'Normal:NormalFloat',
            'FloatBorder:FloatBorder',
            'CursorLine:Visual',
            'Search:None',
          }, ','),
          scrollbar = true,
          direction_priority = {
            menu_north = { 'e', 'w', 'n', 's' },
            menu_south = { 'e', 'w', 's', 'n' },
          },
        },
      },

      ghost_text = {
        enabled = type(vim.g.ai_cmp) == 'boolean' and vim.g.ai_cmp or false,
      },
    },

    snippets = {
      expand = function(snippet)
        local luasnip = require 'luasnip'
        local ok, err = pcall(function()
          luasnip.lsp_expand(snippet)
        end)
        if not ok then
          vim.notify('Failed to expand snippet: ' .. err, vim.log.levels.ERROR)
        end
      end,

      active = function(filter)
        local luasnip = require 'luasnip'
        local ok, result = pcall(function()
          if filter and filter.direction then
            return luasnip.jumpable(filter.direction)
          end
          return luasnip.in_snippet()
        end)
        if not ok then
          vim.notify('Failed to check snippet state: ' .. result, vim.log.levels.ERROR)
          return false
        end
        return result
      end,

      jump = function(direction)
        local luasnip = require 'luasnip'
        local ok, err = pcall(function()
          luasnip.jump(direction)
        end)
        if not ok then
          vim.notify('Failed to jump in snippet: ' .. err, vim.log.levels.ERROR)
        end
      end,
    },
  },
}
