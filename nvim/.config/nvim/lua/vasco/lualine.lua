local lualine, status_ok = pcall(require, 'lualine')

if not status_ok then
  return
end

local colors = require 'colors'
local utils = require 'functions'

local config = {
  options = {
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

ins_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
  function()
    return '%='
  end,
}

ins_left {
  -- Lsp server name
  -- function()
  --   local msg = 'No Active Lsp'
  --   local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  --   local clients = vim.lsp.get_active_clients()
  --   if next(clients) == nil then
  --     return msg
  --   end
  --   for _, client in ipairs(clients) do
  --     local filetypes = client.config.filetypes
  --     if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
  --       return client.name
  --     end
  --   end
  --   return msg
  -- end,
  function()
    msg = 'Inactive'
    local buf_clients = vim.lsp.buf_get_clients()
    if next(buf_clients) == nil then
      if type(msg) == 'boolean' or #msg == 0 then
        return 'Inactive'
      end
      return msg
    end
    local buf_ft = vim.bo.filetype
    local buf_client_names = {}

    for _, client in pairs(buf_clients) do
      if client.name ~= 'null-ls' then
        table.insert(buf_client_names, client.name)
      end
    end

    local supported_formatters = utils.list_registered_formatters(buf_ft)
    vim.list_extend(buf_client_names, supported_formatters)

    local supported_linters = utils.list_registered_linters(buf_ft)
    vim.list_extend(buf_client_names, supported_linters)

    return table.concat(buf_client_names, ', ')
  end,
  icon = ' LSP:',
  color = { fg = colors.base0D },
}

require('lualine').setup(config)
