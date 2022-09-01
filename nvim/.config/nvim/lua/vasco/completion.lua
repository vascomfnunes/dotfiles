local status_ok, cmp = pcall(require, 'cmp')

if not status_ok then
  return
end

local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

cmp.setup {
  enabled = function()
    return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
  end,
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    -- ['<C-j>'] = cmp.mapping.select_next_item(),
    -- ['<C-k>'] = cmp.mapping.select_prev_item(),
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
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
    { name = 'spell' },
    { name = 'buffer', keyword_length = 5 },
  },
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        nvim_lsp = '[LSP]',
        luasnip = '[LuaSnip]',
        spell = '[Spell]',
        buffer = '[Buffer]',
        path = '[Path]',
        nvim_lua = '[Lua]',
      },
    },
  },
  sorting = {
    comparators = {
      cmp.config.compare.exact,
      cmp.config.compare.locality,
      cmp.config.compare.recently_used,
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.sort_text,
      cmp.config.compare.order,
    },
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
  experimental = {
    ghost_text = true,
  },
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
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

require('cmp').setup.filetype({ 'dap-repl', 'dapui_watches' }, {
  sources = {
    { name = 'dap' },
  },
})
