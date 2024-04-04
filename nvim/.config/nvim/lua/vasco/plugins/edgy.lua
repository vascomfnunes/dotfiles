return {
  'folke/edgy.nvim',
  event = 'VeryLazy',
  init = function()
    vim.opt.laststatus = 3
    vim.opt.splitkeep = 'screen'
  end,
  opts = {
    animate = {
      enabled = false,
    },
    left = {},
    right = {
      { ft = 'codecompanion', title = 'Code Companion Chat', size = { width = 0.30 } },
    },
    bottom = {
      {
        ft = 'help',
        size = { height = 20 },
        -- only show help buffers
        filter = function(buf)
          return vim.bo[buf].buftype == 'help'
        end,
      },
      { ft = 'spectre_panel', size = { height = 0.4 } },
    },
  },
}
