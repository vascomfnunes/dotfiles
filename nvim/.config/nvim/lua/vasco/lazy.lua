local config = require 'vasco.config'

-- bootstrap from github
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.notify 'Installing Lazy plugin manager...'
  local success, err = pcall(vim.fn.system, {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  if not success then
    vim.notify('Failed to install lazy.nvim: ' .. err, vim.log.levels.ERROR)
    return
  end
end

vim.opt.runtimepath:prepend(lazypath)

local icons = require 'vasco.utils.icons'

-- load lazy
require('lazy').setup('vasco.plugins', {
  defaults = { lazy = true },
  checker = {
    enabled = true,
    frequency = 7 * 24 * 60 * 60, -- check weekly
    notify = true, -- get a notification when new updates are available
  },
  change_detection = {
    enabled = true,
    notify = true,
  },
  ui = {
    -- a number <1 is a percentage., >1 is a fixed size
    size = { width = 0.8, height = 0.8 },
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = config.border.style,
    icons = {
      cmd = ' ',
      config = icons.cog,
      event = '',
      ft = icons.document,
      init = icons.cog,
      keys = ' ',
      plugin = ' ',
      runtime = ' ',
      source = ' ',
      start = icons.right_arrow,
      task = icons.check,
    },
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
      disabled_plugins = {
        '2html_plugin',
        'tohtml',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'logipat',
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'matchit',
        'tar',
        'tarPlugin',
        'rrhelper',
        'spellfile_plugin',
        'vimball',
        'vimballPlugin',
        'zip',
        'zipPlugin',
        'tutor',
        'rplugin',
        'syntax',
        'synmenu',
        'optwin',
        'compiler',
        'bugreport',
        'ftplugin',
      },
    },
    install = {
      max_concurrent_tasks = 10, -- limit concurrent install tasks
    },
  },
  diff = {
    cmd = 'git', -- command to run the diff
  },
  debug = false,
})
