return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    vim.keymap.set('n', '<leader>cf', function()
      require('conform').format { async = true, lsp_fallback = true }
    end, { desc = 'Format code' }),

    vim.keymap.set('v', '<leader>cf', function()
      require('conform').format { async = true, lsp_fallback = true }
    end, { desc = 'Format code' }),
  },
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
