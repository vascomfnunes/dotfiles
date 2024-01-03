return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup {
      enable_afterquote = true,
      enable_moveright = true,
      ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], '%s+', ''),
      disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
      check_ts = true,
      map_char = {
        all = '(',
        tex = '{',
      },
      ts_config = {
        lua = { 'string', 'source' },
        javascript = { 'string', 'template_string' },
        java = false,
      },
      enable_check_bracket_line = false,
    }

    --  cmp integration
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local cmp = require 'cmp'
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
