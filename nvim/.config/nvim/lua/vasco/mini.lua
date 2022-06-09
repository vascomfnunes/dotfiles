-- MINI
--

local status_ok, statusline = pcall(require, 'mini.statusline')

if not status_ok then
  return
end

local colors = {
  base00 = '#32302f', -- Default Background
  base01 = '#32302f', -- Lighter Background (Used for status bars, line number and folding marks)
  base02 = '#444444', -- Selection Background
  base03 = '#666666', -- Comments, Invisibles, Line Highlighting
  base04 = '#999999', -- Dark Foreground (Used for status bars)
  base05 = '#d4be98', -- Default Foreground, Caret, Delimiters, Operators
  base06 = '#666666', -- Light Foreground (Not often used)
  base07 = '#32302f', -- Light Background (Not often used)
  base08 = '#7daea3', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = '#e78a4e', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = '#ea6962', -- Classes, Markup Bold, Search Text Background
  base0B = '#a9b665', -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = '#d3869b', -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = '#89b482', -- Functions, Methods, Attribute IDs, Headings
  base0E = '#d3869b', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = '#d4be98', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}

local function lsp_active()
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
      local lsp_active = lsp_active()

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

require('mini.base16').setup {
  -- palette based on Gruvbox Material Dark Soft
  palette = colors,
  name = 'minischeme',
  use_cterm = true,
}

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

-- HIGHLIGHTS
--

vim.api.nvim_set_hl(0, 'MiniStatusLineInactive', { bg = colors.base02 })
vim.api.nvim_set_hl(0, 'MiniStatusLineFilename', { bg = colors.base02, fg = colors.base_04 })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = colors.base02, fg = colors.base03 })
vim.api.nvim_set_hl(0, 'Title', { fg = colors.base03 })
vim.api.nvim_set_hl(0, 'SpellBad', { fg = colors.base0A })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = colors.base0B })
vim.api.nvim_set_hl(0, 'CmpItemKind', { fg = colors.base0A })
vim.api.nvim_set_hl(0, 'CmpItemKindSnippet', { fg = colors.base08 })
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = colors.base0A, italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = colors.base09, italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = colors.base0B, italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = colors.base0B, italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticSignError', { fg = colors.base0A })
vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { fg = colors.base09 })
vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { fg = colors.base0D })
vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { fg = colors.base0D })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingError', { fg = colors.base0A })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingWarn', { fg = colors.base09 })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingInfo', { fg = colors.base0D })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingHint', { fg = colors.base0D })
vim.api.nvim_set_hl(0, 'FloatTitle', { fg = colors.base05 })
vim.api.nvim_set_hl(0, 'NVimTreeWindowPicker', { fg = colors.base0A })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = colors.base05 })
vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = colors.base02 })
vim.api.nvim_set_hl(0, 'VertSplit', { bg = 'NONE', fg = colors.base04 })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = colors.base02 })
vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { bg = colors.base00, fg = colors.base05 })
vim.api.nvim_set_hl(0, 'Comment', { fg = colors.base03, italic = true })
