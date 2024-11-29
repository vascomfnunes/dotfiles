return {
  -- requires 'npm install -g live-server' and 'brew install pandoc'
  'davidgranstrom/nvim-markdown-preview',
  ft = 'markdown',
  keys = {
    { '<leader>mp', vim.cmd.MarkdownPreview, desc = 'Preview in browser' },
  },
}
