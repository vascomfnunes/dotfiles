local config = require 'vasco.config'

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    vim.opt.laststatus = 0
  end,
  config = function()
    vim.opt.laststatus = 3
    local lualine = require 'lualine'

    local function lsp_name()
      local buf_clients = vim.lsp.get_clients { bufnr = 0 }
      if #buf_clients > 0 then
        local client_names = {}
        for _, client in ipairs(buf_clients) do
          table.insert(client_names, client.name)
        end
        return table.concat(client_names, ', ')
      end
      return ''
    end

    lualine.setup {
      options = {
        globalstatus = true,
        component_separators = '',
        section_separators = { left = '', right = '' },
        disabled_filetypes = { 'neo-tree' },
        transparent = true,
      },
      sections = {
        lualine_a = {
          { 'mode', right_padding = 2 },
        },
        lualine_b = {
          'branch',
          'filesize',
          'diff',
          'diagnostics',
          { lsp_name, icon = ' ', color = { fg = config.border.color, bg = 'NONE' } },
        },
        lualine_c = { '' },
        lualine_x = { 'encoding' },
        lualine_y = { '' },
        lualine_z = {
          { 'filename', left_padding = 2 },
        },
      },
    }
  end,
}
