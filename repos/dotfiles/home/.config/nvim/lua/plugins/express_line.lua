vim.cmd [[packadd plenary.nvim]]
vim.cmd [[packadd express_line.nvim]]

local builtin = require('el.builtin')
local extensions = require('el.extensions')
local sections = require('el.sections')
local subscribe = require('el.subscribe')

local git_icon = subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, bufnr)
  local icon = extensions.file_icon(_, bufnr)
  if icon then
    return icon .. ' '
  end

  return ''
end)

local git_branch = subscribe.buf_autocmd("el_git_branch", "BufEnter", function(window, buffer)
  local branch = extensions.git_branch(window, buffer)
  if branch then
    return ' ' .. extensions.git_icon() .. ' ' .. branch
  end
end)

require('el').setup {
  generator = function(_, _)
    return {
      extensions.gen_mode {format_string = ' %s '},
      git_branch,
      ' ',
      sections.split,
      git_icon,
      sections.maximum_width(builtin.file_relative, 0.30),
      sections.collapse_builtin {' ', builtin.modified_flag},
      sections.split,
      builtin.line_with_width(3),
      sections.collapse_builtin {'[', builtin.help_list, builtin.readonly_list, ']'},
      builtin.filetype
    }
  end
}
