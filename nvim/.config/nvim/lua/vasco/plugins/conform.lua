return {
  'stevearc/conform.nvim',
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettierd', 'eslint' },
      html = { 'prettierd' },
      css = { 'prettierd' },
      scss = { 'prettierd' },
      sh = { 'shfmt' },
      markdown = { 'prettierd' },
    },
  },
}
