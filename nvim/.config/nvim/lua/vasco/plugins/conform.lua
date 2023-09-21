return {
  'stevearc/conform.nvim',
  event = 'VeryLazy',
  opts = {
    formatters_by_ft = {
      javascript = { 'prettierd', 'eslint' },
      html = { 'prettierd' },
      css = { 'prettierd' },
      scss = { 'prettierd' },
      sh = { 'shfmt' },
      markdown = { 'prettierd' },
    },
  },
}
