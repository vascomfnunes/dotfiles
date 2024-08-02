return {
  'folke/edgy.nvim',
  event = 'VeryLazy',
  init = function()
    vim.opt.laststatus = 3
    vim.opt.splitkeep = 'screen'
  end,
  opts = function(_, opts)
    opts.right = opts.right or {}
    table.insert(opts.right, {
      ft = 'copilot-chat',
      title = 'Copilot Chat',
      size = { width = 50 },
    })
  end,
}
