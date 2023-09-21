return {
  'stevearc/conform.nvim',
  event = 'VeryLazy',
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettierd', 'eslint' },
      html = { 'prettierd' },
      css = { 'prettierd' },
      scss = { 'prettierd' },
    },
  },
}
