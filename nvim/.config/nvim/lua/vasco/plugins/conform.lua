return {
  'stevearc/conform.nvim',
  event = 'VeryLazy',
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd" },
      html = { 'prettierd' },
      css = { 'prettier' },
      scss = { 'prettier' }
    },
  },
}
