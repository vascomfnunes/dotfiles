return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      desc = 'Format code',
      mode = { 'n', 'v' },
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'eslint' },
      javascriptreact = { 'eslint' },
      typescript = { 'eslint' },
      typescriptreact = { 'eslint' },
      html = { 'prettierd' },
      json = { 'prettierd' },
      css = { 'prettierd' },
      scss = { 'prettierd' },
      sh = { 'shfmt' },
      markdown = { 'prettierd' },
      yaml = { 'prettierd' },
      eruby = { 'htmlbeautifier' },
    },
  },
}
