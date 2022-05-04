-- PLUGINS
--

local fn = vim.fn
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  vim.notify('Installing packer... Please, close and reopen Neovim.', vim.log.levels.WARN)
  packer_bootstrap = fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  vim.cmd 'packadd packer.nvim'
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')

if not status_ok then
  return
end

-- Have packer to use a popup window
packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
  },
  autoremove = true,
}

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'nvim-treesitter/nvim-treesitter'

  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }

  use 'tpope/vim-projectionist'

  use {
    'nvim-telescope/telescope.nvim', -- requires 'brew install rg' for live_grep
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
    },
    command = 'Telescope',
  }

  use 'windwp/nvim-autopairs'

  use { 'vim-test/vim-test', command = { 'TestNearest', 'TestFile', 'TestSuite' } }

  use {
    'neovim/nvim-lspconfig',
    'williamboman/nvim-lsp-installer',
  }

  use {
    'hrsh7th/nvim-cmp',
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'f3fora/cmp-spell',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
  }

  use { 'davidgranstrom/nvim-markdown-preview', cmd = 'MarkdownPreview' } -- requires 'npm install -g live-server' and 'brew install pandoc'

  use 'jose-elias-alvarez/null-ls.nvim'

  use 'PlatyPew/format-installer.nvim'

  use 'aserowy/tmux.nvim'

  use 'windwp/nvim-ts-autotag'

  use 'echasnovski/mini.nvim'

  use 'norcalli/nvim-colorizer.lua'

  use {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap', 'theHamsta/nvim-dap-virtual-text' },
    command = { 'DapToggleBreakpoint', 'DapContinue' },
  }

  use { 'TimUntersberger/neogit', cmd = { 'Neogit' } }

  use { 'github/copilot.vim', cmd = { 'Copilot' } }

  use { 'rizzatti/dash.vim', cmd = 'Dash' }

  use 'kyazdani42/nvim-tree.lua'

  use 'kyazdani42/nvim-web-devicons'

  use 'stevearc/dressing.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
