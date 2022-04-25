-- bootstrap from github
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.notify 'Installing Lazy plugin manager...'
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'git@github.com:folke/lazy.nvim.git',
    lazypath,
  }
end

vim.opt.runtimepath:prepend(lazypath)

local icons = require 'vasco.helpers.icons'

-- load lazy
require('lazy').setup('vasco.plugins', {
  defaults = { lazy = true },
  checker = { enabled = true },
  ui = {
    -- a number <1 is a percentage., >1 is a fixed size
    size = { width = 0.8, height = 0.8 },
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = 'rounded',
    icons = {
      cmd = ' ',
      config = icons.cog,
      event = '',
      ft = icons.document,
      init = icons.cog,
      keys = ' ',
      plugin = ' ',
      runtime = ' ',
      source = ' ',
      start = icons.right_arrow,
      task = icons.check,
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  debug = false,
})
