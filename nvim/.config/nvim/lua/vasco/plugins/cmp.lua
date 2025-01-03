local config = require 'vasco.config'

return {
  'hrsh7th/nvim-cmp',
  version = false,
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
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

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
    end

    local lspkind = require 'lspkind'

    return {
      completion = {
        completeopt = 'menu,menuone,noinsert',
        border = config.border.style,
        winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None,NormalFloat:Normal',
        col_offset = -3,
        side_padding = 0,
        scrollbar = true,
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-q>'] = cmp.mapping.abort(),
        ['<C-l>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping(function(fallback)
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
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources({
        { name = 'copilot', priority = 1000 },
        { name = 'nvim_lsp', priority = 900 },
        { name = 'luasnip', priority = 750 },
        { name = 'path', priority = 500 },
      }, {
        { name = 'buffer', priority = 250 },
      }),
      sorting = {
        priority_weight = 2.0,
        comparators = {
          cmp.config.compare.exact,
          cmp.config.compare.locality,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.offset,
          cmp.config.compare.order,
        },
      },
      window = {
        completion = {
          border = config.border.style,
          winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
          col_offset = -3,
          side_padding = 0,
          scrollbar = true,
        },
        documentation = {
          border = config.border.style,
          winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
          scrollbar = true,
          max_height = 20,
        },
      },
      formatting = {
        format = lspkind.cmp_format {
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
          symbol_map = { Copilot = '' },
          before = function(entry, vim_item)
            vim_item.menu = ({
              copilot = '[Copilot]',
              nvim_lsp = '[LSP]',
              luasnip = '[Snippet]',
              buffer = '[Buffer]',
              path = '[Path]',
            })[entry.source.name]
            return vim_item
          end,
        },
      },
      experimental = {
        ghost_text = {
          hl_group = 'CmpGhostText',
        },
      },
    }
  end,
  config = function(_, opts)
    local cmp = require 'cmp'
    cmp.setup(opts)

    -- Set up specific completion for cmdline
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })
  end,
}
