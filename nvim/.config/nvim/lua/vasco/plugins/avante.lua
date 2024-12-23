return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false, -- set this if you want to always pull the latest change
  opts = {
    provider = 'copilot',
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make BUILD_FROM_SOURCE=true',
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
  keys = {
    { '<leader>at', '<cmd>AvanteToggle<cr>', desc = 'Toggle' },
    { '<leader>ax', '<cmd>AvanteClear<cr>', desc = 'Clear history' },
  },
}
