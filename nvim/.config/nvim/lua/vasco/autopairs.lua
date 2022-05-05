local status_ok, autopairs = pcall(require, 'nvim-autopairs')

if not status_ok then
  return
end

autopairs.setup {
  check_ts = true,
  enable_afterquote = true,
  enable_moveright = true,
  enable_check_bracket_line = true,
  disable_filetype = { 'TelescopePrompt' },
  break_line_filetype = nil,
}

-- handle <CR> mapping with nvim-cmp
local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
local cmp = require 'cmp'
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })
