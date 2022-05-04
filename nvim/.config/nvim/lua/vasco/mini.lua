-- MINI
--

local status_ok, comment = pcall(require, 'mini.comment')

if not status_ok then
  return
end

comment.setup()
require('mini.tabline').setup()
require('mini.statusline').setup()
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
require('mini.indentscope').setup {
  draw = {
    delay = 100,
    animation = require('mini.indentscope').gen_animation 'none',
  },
  symbol = '│',
}

require('mini.base16').setup {
  -- palette based on Gruvbox Material Dark Soft
  palette = {
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
  },
  name = 'minischeme',
  use_cterm = true,
}
