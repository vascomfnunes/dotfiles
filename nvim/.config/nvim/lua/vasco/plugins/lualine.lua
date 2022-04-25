local colors = require 'vasco.helpers.colors'

local M = {
  'nvim-lualine/lualine.nvim',
}

M.event = 'VimEnter'

function M.config()
  local lsp = {
    function()
      local msg = 'LS Inactive'
      local buf_clients = vim.lsp.buf_get_clients()

      if next(buf_clients) == nil then
        if type(msg) == 'boolean' or #msg == 0 then
          return 'LS Inactive'
        end
        return msg
      end

      local buf_client_names = {}

      for _, client in pairs(buf_clients) do
        table.insert(buf_client_names, client.name)
      end

      local unique_client_names = vim.fn.uniq(buf_client_names)
      local language_servers = '[' .. table.concat(unique_client_names, ', ') .. ']'

      return language_servers
    end,
    color = { fg = colors.grey },
  }

  require('lualine').setup {
    options = {
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      icons_enabled = true,
      globalstatus = true,
      always_divide_middle = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
      disabled_filetypes = {
        statusline = { 'aerial', 'NeogitStatus', 'spectre_panel' },
        winbar = {},
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { { 'filename', color = { fg = colors.yellow } }, lsp },
      lualine_x = { { 'encoding', color = { fg = colors.grey } }, { 'filetype', color = { colors.fg } } },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { 'nvim-tree' },
  }
end

return M
