local config = require 'vasco.config'

return {
  'hrsh7th/nvim-cmp',
  version = false, -- last release is way too old
  event = 'InsertEnter',
  dependencies = {
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    {
      'zbirenbaum/copilot-cmp',
      dependencies = 'github/copilot.vim',
      opts = {},
      config = function(_, opts)
        local copilot_cmp = require 'copilot_cmp'
        copilot_cmp.setup(opts)
      end,
    },
  },
  opts = function()
    vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local defaults = require 'cmp.config.default'()

    local has_words_before = function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      return (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or '')
        :sub(cursor[2], cursor[2])
        :match '%s'
    end

    local lspkind = require 'lspkind'

    return {
      completion = {
        completeopt = 'menu,menuone,noinsert',
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
      sources = cmp.config.sources {
        { name = 'copilot' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      },
      window = {
        completion = {
          border = config.border.style,
          winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
          col_offset = -3,
          side_padding = 0,
          scrollbar = true,
        },
        documentation = {
          border = config.border.style,
          winhighlight = 'FloatBorder:FloatBorder',
          scrollbar = true,
        },
      },
      formatting = {
        format = lspkind.cmp_format {
          mode = 'symbol',
          max_width = 50,
          symbol_map = { Copilot = '' },
        },
      },
      experimental = {
        ghost_text = {
          hl_group = 'CmpGhostText',
        },
      },
      sorting = defaults.sorting,
    }
  end,
}
