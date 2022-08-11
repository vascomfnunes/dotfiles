-- MINI
--

local status_ok, statusline = pcall(require, 'mini.statusline')

if not status_ok then
  return
end

vim.g.minibase16_disable=true
vim.g.miniai_disable=true
vim.g.minicompletion_disable=true
vim.g.minicursorword_disable=true
vim.g.minidoc_disable=true
vim.g.minifuzzy_disable=true
vim.g.minijump_disable=true
vim.g.minimisc_disable=true
vim.g.minisessions_disable=true
vim.g.ministarter_disable=true
vim.g.minitest_disable=true
vim.g.minitrailspace_disable=true

local function get_lsp_active()
  local clients = {}

  for _, client in pairs(vim.lsp.buf_get_clients(0)) do
    clients[#clients + 1] = client.name
  end

  return 'LSP: ' .. table.concat(clients, ' ')
end

statusline.setup {
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
      local spell = vim.wo.spell and (MiniStatusline.is_truncated(120) and 'S' or 'SPELL') or ''
      local git = MiniStatusline.section_git { trunc_width = 75 }
      local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
      local filename = MiniStatusline.section_filename { trunc_width = 140 }
      local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
      local lsp_active = get_lsp_active()

      return MiniStatusline.combine_groups {
        { hl = mode_hl, strings = { mode, spell } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineFileinfo', strings = { lsp_active, fileinfo } },
      }
    end,
  },
}

require('mini.tabline').setup()
require('mini.jump2d').setup()

require('mini.indentscope').setup {
  draw = {
    delay = 100,
    animation = require('mini.indentscope').gen_animation 'none',
  },
  symbol = '│',
}

require('mini.comment').setup()

require('mini.surround').setup {
  mappings = {
    add = 'sa', -- Add surrounding
    delete = 'sd', -- Delete surrounding
    find = 'sf', -- Find surrounding (to the right)
    find_left = 'sF', -- Find surrounding (to the left)
    highlight = 'sh', -- Highlight surrounding
    replace = 'cs', -- Replace surrounding
    update_n_lines = 'sn', -- Update `n_lines`
  },
}
