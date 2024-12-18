return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'
    local Rule = require 'nvim-autopairs.rule'

    npairs.setup {
      enable_bracket_in_quote = true,
      enable_moveright = true,
      ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], '%s+', ''),
      disable_filetype = { 'vim' },
      check_ts = true,
      map_char = {
        all = '(',
        tex = '{',
      },
      ts_config = {
        lua = { 'string', 'source' },
        javascript = { 'string', 'template_string' },
        typescript = { 'string', 'template_string' },
        python = { 'string' },
        java = false,
      },
      enable_check_bracket_line = false,
      fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey = 'Comment',
      },
    }

    -- Add spaces between parentheses
    npairs.add_rules {
      Rule(' ', ' '):with_pair(function(opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({ '()', '[]', '{}' }, pair)
      end),
      -- Add space after function name
      Rule('(', ')'):with_pair(function(opts)
        local line = opts.line
        local col = opts.col
        return line:sub(col - 1, col - 1):match '%w' ~= nil
      end):use_key '(',
    }
  end,
}
