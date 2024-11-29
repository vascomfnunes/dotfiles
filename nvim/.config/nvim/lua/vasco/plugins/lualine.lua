return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = ' '
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require 'lualine_require'
    lualine_require.require = require

    local icons = require 'vasco.utils.icons'

    vim.o.laststatus = vim.g.lualine_laststatus

    local function IsZoomedIn()
      if vim.t['simple-zoom'] == nil then
        return ''
      elseif vim.t['simple-zoom'] == 'zoom' then
        return '󰍉'
      end
    end

    local opts = {
      options = {
        theme = 'auto',
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'ministarter' } },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },

        lualine_c = {
          {
            'diagnostics',
            symbols = {
              error = icons.error,
              warn = icons.warning,
              info = icons.info,
              hint = icons.hint,
            },
          },
          { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
          { 'filename' },
          { IsZoomedIn },
        },
        lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
            },
          {
            'diff',
            symbols = {
              added = icons.git_add,
              modified = icons.git_change,
              removed = icons.git_delete,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
          { 'location', padding = { left = 0, right = 1 } },
        },
      },
      extensions = { 'neo-tree', 'lazy' },
    }

    return opts
  end,
}
