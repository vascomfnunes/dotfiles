local vim = vim
local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'

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

local function insertspace(count)
  if count and count > 0 then
    return ' '
  else
    return ''
  end
end

-- Components --- {{{

-- Helpers / common --- {{{2
local Align = {
  provider = '%=',
}

local Space = {
  provider = ' ',
}
-- 2}}}

-- Mode --- {{{2
local ViMode = {
  static = {
    mode_names = {
      -- normal
      n = ' N  ',
      no = ' N  ',
      nov = ' N  ',
      noV = ' N  ',
      ['\22 n'] = ' N  ',
      niI = ' N  ',
      niR = ' N  ',
      niV = ' N  ',
      nt = ' N  ',
      -- visual
      v = ' V  ',
      vs = ' V  ',
      V = ' V  ',
      Vs = ' V  ',
      ['\22'] = ' V  ',
      ['\22s'] = ' V  ',
      -- insert
      i = ' I פֿ ',
      ic = ' I פֿ ',
      ix = ' I פֿ ',
      -- command
      c = ' C  ',
      s = ' S  ',
      S = ' S  ',
      ['\19'] = ' S  ',
      -- replace
      R = ' R  ',
      Rc = ' R  ',
      Rx = ' R  ',
      Rv = ' R  ',
      Rvc = ' R  ',
      Rvx = ' R  ',

      -- x
      cv = ' E  ',
      r = ' .  ',
      rm = ' M  ',
      ['r?'] = ' ?  ',
      ['!'] = ' !  ',
      t = ' T  ',
    },
  },
  provider = function(self)
    return '%2(' .. self.mode_names[vim.fn.mode(1)] .. '%) '
  end,
  hl = function(self)
    local color = self:mode_color()
    return {
      bg = color,
      fg = colors.base00,
      bold = true,
    }
  end,
}

-- File info --- {{{2

local WorkDir = {
  provider = function()
    local cwd = vim.fn.expand '%:h'
    cwd = vim.fn.fnamemodify(cwd, ':.')
    if not conditions.width_percent_below(#cwd, 0.33) then
      cwd = vim.fn.pathshorten(cwd)
    end
    local trail = cwd:sub(-1) == '/' and '' or '/'
    return cwd .. trail
  end,
  condition = function()
    return not conditions.buffer_matches {
      buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
      filetype = { '^git.*', 'fugitive' },
    }
  end,
  hl = { fg = colors.base03, italic = true },
}
local FileType = {
  provider = function()
    return vim.bo.filetype
  end,
  hl = {
    fg = colors.base05,
    bold = true,
  },
}

local FileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  on_click = {
    callback = function()
      vim.defer_fn(function()
        require('telescope.builtin').buffers()
      end, 100)
    end,
    name = 'heirline_buffers',
  },
}

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, {
      default = true,
    })
  end,
  provider = function(self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function(self)
    return {
      fg = self.icon_color,
    }
  end,
}

local FileName = {
  provider = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ':t.')
    if filename == '' then
      return '[No Name]'
    end
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = {
    fg = colors.base02,
  },
}

local FileFlags = {
  {
    provider = function()
      if vim.bo.modified then
        return ' ﯽ'
      end
    end,
    hl = { fg = colors.base08 },
  },
  {
    provider = function()
      if not vim.bo.modifiable or vim.bo.readonly then
        return ' '
      end
    end,
    hl = {
      fg = colors.base09,
    },
  },
}

FileNameBlock = utils.insert(FileNameBlock, FileIcon, WorkDir, FileName, FileFlags, {
  provider = '%<',
})

local HelpFilename = {
  condition = function()
    return vim.bo.filetype == 'help'
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ':t')
  end,
  hl = {
    fg = colors.base0D,
  },
}

local ScrollBar = {
  static = {
    sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = { fg = colors.base0B },
}

-- 2}}}

-- Git --- {{{2
local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.added = self.status_dict.added or 0
    self.removed = self.status_dict.removed or 0
    self.changed = self.status_dict.changed or 0
    self.has_changes = self.added ~= 0 or self.removed ~= 0 or self.changed ~= 0
  end,
  static = {
    branch_icon = ' ',
    added_icon = ' ',
    removed_icon = ' ',
    changed_icon = ' ',
  },

  hl = {
    bg = colors.base00,
    fg = colors.base08,
  },

  { -- git branch icon
    hl = {
      fg = colors.base0A,
    },
    provider = function(self)
      return self.branch_icon
    end,
  },
  { -- git branch name
    provider = function(self)
      local branch_name = self.status_dict.head
      if string.len(branch_name) > 18 then
        branch_name = string.sub(branch_name, 1, 15) .. '...'
      end
      return branch_name
    end,
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ' (',
  },
  {
    provider = function(self)
      local count = self.added or 0
      return count > 0 and (self.added_icon .. count .. insertspace(self.changed + self.removed))
    end,
    hl = {
      fg = colors.base0B,
    },
  },
  {
    provider = function(self)
      local count = self.removed or 0
      return count > 0 and (self.removed_icon .. count .. insertspace(self.changed))
    end,
    hl = {
      fg = colors.base0A,
    },
  },
  {
    provider = function(self)
      local count = self.changed or 0
      return count > 0 and (self.changed_icon .. count)
    end,
    hl = {
      fg = colors.base08,
    },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ')',
  },
}

local GitBlock = {
  condition = conditions.is_git_repo,
  Git,
  on_click = {
    callback = function()
      vim.defer_fn(function()
        require('telescope.builtin').git_branches()
      end, 100)
    end,
    name = 'heirline_git_branches',
  },
}

-- StatusLines --- {{{
local DefaultStatusline = { GitBlock, Align, FileType, Space, ScrollBar }

local InactiveStatusLine = {
  condition = function()
    return not conditions.is_active()
  end,
  FileNameBlock,
  {
    provider = '%<',
  },
  Align,
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches {
      buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
      filetype = { '^git.*', 'fugitive' },
    }
  end,
  FileType,
  {
    provider = '%q',
  },
  Space,
  HelpFilename,
  Align,
}

local StatusLines = {
  hl = function()
    if conditions.is_active() then
      return {
        bg = colors.base00,
      }
    else
      return {
        bg = colors.base08,
      }
    end
  end,
  static = {
    mode_colors = {
      n = colors.base08,
      i = colors.base0B,
      v = colors.base0C,
      ['\22'] = colors.base08,
      c = colors.base09,
      s = colors.base0E,
      ['\19'] = colors.base0E,
      r = colors.base0A,
      ['!'] = colors.base09,
      t = colors.base05,
    },
    mode_color = function(self)
      local mode = conditions.is_active() and vim.fn.mode(1):lower() or 'n'
      return self.mode_colors[mode]
    end,
  },

  fallthrough = false,

  SpecialStatusline,
  InactiveStatusLine,
  DefaultStatusline,
}
-- }}}

-- Winbars --- {{{
local DefaultWinbar = { ViMode, Space, FileNameBlock, Space }

local InactiveWinbar = {
  condition = function()
    return not conditions.is_active()
  end,
  hl = {
    bg = colors.base00,
    fg = colors.base03,
    force = true,
  },
  FileNameBlock,
  Space,
}

local WinBars = {
  hl = function()
    if conditions.is_active() then
      return {
        bg = colors.base00,
      }
    else
      return {
        bg = colors.base00,
      }
    end
  end,
  static = {
    mode_colors = {
      n = colors.base0B,
      i = colors.base0A,
      v = colors.base0C,
      ['\22'] = colors.base08,
      c = colors.base0A,
      s = colors.base0E,
      ['\19'] = colors.base0E,
      r = colors.base0A,
      ['!'] = colors.base09,
      t = colors.base05,
    },
    mode_color = function(self)
      local mode = conditions.is_active() and vim.fn.mode(1):lower() or 'n'
      return self.mode_colors[mode]
    end,
  },
  fallthrough = false,
  { -- Hide the winbar for special buffers
    condition = function()
      return conditions.buffer_matches {
        buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
        filetype = { '^git.*', 'fugitive' },
      }
    end,
    init = function()
      vim.opt_local.winbar = nil
    end,
  },

  InactiveWinbar,
  DefaultWinbar,
}
-- }}}

require('heirline').setup(StatusLines, WinBars)
