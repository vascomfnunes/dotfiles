return {
  -- requires 'npm install -g live-server' and 'brew install pandoc'
  'davidgranstrom/nvim-markdown-preview',
  ft = 'markdown',
  keys = {
    vim.keymap.set('n', '<leader>mp', vim.cmd.MarkdownPreview, { desc = 'Preview in browser' }),
  },
}
