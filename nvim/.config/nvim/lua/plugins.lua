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
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

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

return packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig'

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = "require('vasco.treesitter')" }

  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = "require('vasco.gitsigns')",
    event = 'BufRead',
  }

  use { 'tpope/vim-projectionist', config = "require('vasco.projectionist')" }

  use {
    'nvim-telescope/telescope.nvim', -- requires 'brew install rg' for live_grep
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
    },
    command = 'Telescope',
    config = "require('vasco.telescope')",
  }

  use { 'vim-test/vim-test', command = { 'TestNearest', 'TestFile', 'TestSuite' } }

  use { 'jose-elias-alvarez/nvim-lsp-ts-utils', after = { 'nvim-treesitter' } }

  use { 'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter' }

  use {
    { 'hrsh7th/nvim-cmp', config = "require('vasco.completion')" },
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
    { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
    { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp' },
    { 'f3fora/cmp-spell', after = 'nvim-cmp' },
    { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
    {
      'L3MON4D3/LuaSnip',
      requires = 'rafamadriz/friendly-snippets',
      after = 'cmp_luasnip',
      config = "require('vasco.luasnip')",
    },
    'onsails/lspkind.nvim',
  }

  use 'williamboman/nvim-lsp-installer'

  use { 'windwp/nvim-autopairs', after = { 'nvim-treesitter', 'nvim-cmp' }, config = "require('vasco.autopairs')" }

  use { 'davidgranstrom/nvim-markdown-preview', cmd = 'MarkdownPreview' } -- requires 'npm install -g live-server' and 'brew install pandoc'

  use { 'jose-elias-alvarez/null-ls.nvim', config = "require('vasco.null-ls')" }

  use { 'jedrzejboczar/possession.nvim', config = "require('vasco.possession')" }

  use 'PlatyPew/format-installer.nvim'

  use { 'aserowy/tmux.nvim', config = "require('vasco.tmux')" }

  use { 'windwp/nvim-ts-autotag', config = "require('vasco.autotag')" }

  use { 'echasnovski/mini.nvim', config = "require('vasco.mini')" }

  use { 'folke/which-key.nvim', config = "require('vasco.whichkey')", event = 'BufWinEnter' }

  use { 'norcalli/nvim-colorizer.lua', config = "require('vasco.colorizer')" }

  use 'nvim-pack/nvim-spectre'

  use {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap', 'theHamsta/nvim-dap-virtual-text' },
    command = { 'DapToggleBreakpoint', 'DapContinue' },
    config = "require('vasco.dap')",
  }

  use { 'TimUntersberger/neogit', cmd = { 'Neogit' } }

  use { 'github/copilot.vim', cmd = { 'Copilot' } }

  use { 'rizzatti/dash.vim', cmd = 'Dash' }

  use { 'kyazdani42/nvim-tree.lua', config = "require('vasco.nvim-tree')" }

  use 'kyazdani42/nvim-web-devicons'

  use { 'stevearc/dressing.nvim', requires = 'MunifTanjim/nui.nvim' }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
