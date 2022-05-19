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

-- Have packer to use a pop-up window
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

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = "require('vasco.treesitter')",
    requires = {
      'jose-elias-alvarez/nvim-lsp-ts-utils',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'RRethy/nvim-treesitter-endwise',
      {
        'lewis6991/spellsitter.nvim',
        config = function()
          require('spellsitter').setup()
        end,
      },
    },
  }

  use {
    'danymat/neogen',
    config = function()
      require('neogen').setup {}
    end,
    requires = 'nvim-treesitter/nvim-treesitter',
  }

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
    cmd = 'Telescope',
    config = "require('vasco.telescope')",
  }

  use {
    'rcarriga/vim-ultest',
    config = "require('vasco.ultest')",
    run = ':UpdateRemotePlugins',
    requires = { 'vim-test/vim-test' },
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'f3fora/cmp-spell',
      'saadparwaiz1/cmp_luasnip',
    },
    config = "require('vasco.completion')",
  }

  use { 'tpope/vim-ragtag', ft = { 'ruby', 'eruby' } }

  use {
    'L3MON4D3/LuaSnip',
    requires = 'rafamadriz/friendly-snippets',
    config = "require('vasco.luasnip')",
  }

  use 'onsails/lspkind-nvim'

  use 'williamboman/nvim-lsp-installer'

  use { 'windwp/nvim-autopairs', after = { 'nvim-treesitter', 'nvim-cmp' }, config = "require('vasco.autopairs')" }

  use { 'davidgranstrom/nvim-markdown-preview', cmd = 'MarkdownPreview' } -- requires 'npm install -g live-server' and 'brew install pandoc'

  use {
    'jakewvincent/mkdnflow.nvim',
    ft = 'markdown',
    config = function()
      require('mkdnflow').setup {}
    end,
  }

  use { 'mzlogin/vim-markdown-toc', ft = 'markdown' }

  use { 'jose-elias-alvarez/null-ls.nvim', config = "require('vasco.null-ls')" }

  use { 'jedrzejboczar/possession.nvim', config = "require('vasco.possession')" }

  use 'PlatyPew/format-installer.nvim'

  use { 'aserowy/tmux.nvim', config = "require('vasco.tmux')" }

  use { 'windwp/nvim-ts-autotag', config = "require('vasco.autotag')" }

  use { 'echasnovski/mini.nvim', config = "require('vasco.mini')" }

  use { 'folke/which-key.nvim', config = "require('vasco.whichkey')", keys = { '<leader>' } }

  use { 'norcalli/nvim-colorizer.lua', config = "require('vasco.colorizer')" }

  use { 'nvim-pack/nvim-spectre', event = 'VimEnter' }

  use {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap', 'theHamsta/nvim-dap-virtual-text' },
    config = "require('vasco.dap')",
  }

  use {
    'TimUntersberger/neogit',
    cmd = { 'Neogit' },
    config = "require('neogen').setup({ snippet_engine = 'luasnip' })",
  }

  use { 'github/copilot.vim', cmd = 'Copilot' }

  use { 'rizzatti/dash.vim', cmd = 'Dash' }

  use { 'kyazdani42/nvim-tree.lua', config = "require('vasco.nvim-tree')", cmd = 'NvimTreeToggle' }

  use 'kyazdani42/nvim-web-devicons'

  use { 'romainl/vim-cool', event = 'VimEnter' }

  use { 'stevearc/dressing.nvim', requires = 'MunifTanjim/nui.nvim' }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
