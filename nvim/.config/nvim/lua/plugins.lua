-- PLUGINS
--

local fn = vim.fn
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap

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
  use { 'wbthomason/packer.nvim', commit = '90b323bccc04ad9b23c971a85813a1405c7725a8' }

  use { 'lewis6991/impatient.nvim', commit = 'b842e16ecc1a700f62adb9802f8355b99b52a5a6' }

  use { 'nathom/filetype.nvim', commit = 'b522628a45a17d58fc0073ffd64f9dc9530a8027' }

  use { 'neovim/nvim-lspconfig', commit = 'da7461b596d70fa47b50bf3a7acfaef94c47727d' }

  use {
    'nvim-treesitter/nvim-treesitter',
    commit = '2bb9bb73861228a50de3d22d26f73c79d221a696',
    run = ':TSUpdate',
    config = "require('vasco.treesitter')",
    requires = {
      {
        'jose-elias-alvarez/typescript.nvim',
        commit = '4f362c92c1f2f41c9bb13e72106b8719ae3ff379',
        config = [[ require("typescript").setup({})]],
      },
      { 'JoosepAlviste/nvim-ts-context-commentstring', commit = '37a97a04c39f26fffe7745815517e1ce1a0eb3be' },
      { 'RRethy/nvim-treesitter-endwise', commit = '301ae86f057b077ee4865065023b0cae5aedb86a' },
      {
        'lewis6991/spellsitter.nvim',
        commit = 'eb74c4b1f4240cf1a7860877423195cec6311bd5',
        config = function()
          require('spellsitter').setup()
        end,
      },
      {
        'p00f/nvim-ts-rainbow',
        commit = '0c19f1eda263a1d44b6741e727fef223886c80a8',
      },
    },
  }

  use {
    'danymat/neogen',
    commit = 'c5a0c39753808faa41dea009d41dd686732c6774',
    config = function()
      require('neogen').setup {}
    end,
    requires = { 'nvim-treesitter/nvim-treesitter' },
  }

  use {
    'lewis6991/gitsigns.nvim',
    commit = '79c55eb553bb68840539651b083937f1010ba4db',
    requires = 'nvim-lua/plenary.nvim',
    config = "require('vasco.gitsigns')",
    event = 'BufRead',
  }

  use {
    'sitiom/nvim-numbertoggle',
    commit = '1b10222a338b511a9f54ad4ace9abe1d054fdf3b',
    config = function()
      require('numbertoggle').setup()
    end,
  }

  use {
    'kevinhwang91/nvim-ufo',
    commit = '0ed92b53e5f356d1b9dfa2bf39d152620a3874e0',
    requires = 'kevinhwang91/promise-async',
    config = "require('vasco.ufo')",
  }

  use {
    'glepnir/lspsaga.nvim',
    branch = 'main',
    commit = '5f59e0c024248086e4737c2371309ca586dda4e4',
    config = "require('vasco.saga')",
  }

  use {
    'tpope/vim-projectionist',
    commit = 'd4aee3035699b82b3789cee0e88dad0e38c423ab',
    config = "require('vasco.projectionist')",
  }

  use {
    'nvim-telescope/telescope.nvim', -- requires 'brew install rg' for live_grep
    commit = '28dc08f614f45d37ad90f170935f1f4e12559aeb',
    requires = {
      { 'nvim-lua/plenary.nvim', commit = '31807eef4ed574854b8a53ae40ea3292033a78ea' },
      { 'nvim-telescope/telescope-fzy-native.nvim', commit = '7b3d2528102f858036627a68821ccf5fc1d78ce4' },
    },
    cmd = 'Telescope',
    config = "require('vasco.telescope')",
  }

  use {
    'nvim-neotest/neotest',
    commit = '0ba2cb51786c2eead02fa2ca001bd5c1b6262afe',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
      { 'antoinemadec/FixCursorHold.nvim', commit = '5aa5ff18da3cdc306bb724cf1a138533768c9f5e' },
      { 'olimorris/neotest-rspec', commit = 'f1d33d23950073faca6361aaae3f9efd23d6a42b' },
      { 'haydenmeade/neotest-jest', commit = '408245bec62813ed858de49ca07172d3f018a79f' },
    },
    config = "require('vasco.neotest')",
  }

  use {
    'hrsh7th/nvim-cmp',
    commit = 'b1ebdb0a17daaad13606b802780313a32e59781b',
    requires = {
      { 'hrsh7th/cmp-nvim-lsp', commit = 'affe808a5c56b71630f17aa7c38e15c59fd648a8' },
      { 'hrsh7th/cmp-nvim-lua', commit = 'd276254e7198ab7d00f117e88e223b4bd8c02d21' },
      { 'hrsh7th/cmp-buffer', commit = '62fc67a2b0205136bc3e312664624ba2ab4a9323' },
      { 'hrsh7th/cmp-path', commit = '466b6b8270f7ba89abd59f402c73f63c7331ff6e' },
      { 'hrsh7th/cmp-cmdline', commit = 'c36ca4bc1dedb12b4ba6546b96c43896fd6e7252' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help', commit = '007dd2740d9b70f2688db01a39d6d25b7169cd57' },
      { 'f3fora/cmp-spell', commit = '5602f1a0de7831f8dad5b0c6db45328fbd539971' },
      { 'saadparwaiz1/cmp_luasnip', commit = 'a9de941bcbda508d0a45d28ae366bb3f08db2e36' },
    },
    config = "require('vasco.completion')",
  }

  use { 'tpope/vim-ragtag', commit = '51b313e8a2e3a44f37b9d625bc0d461e9066b7e9', ft = { 'ruby', 'eruby' } }

  use {
    'L3MON4D3/LuaSnip',
    commit = 'faa525713e1244551877a4d89646a10f3c3fa31e',
    requires = { 'rafamadriz/friendly-snippets' },
    config = "require('vasco.luasnip')",
  }

  use { 'onsails/lspkind-nvim', commit = '57e5b5dfbe991151b07d272a06e365a77cc3d0e7' }

  use {
    'williamboman/mason.nvim',
    commit = '5dbb22a9a44b97f0e7e36e4d0138d9633a338f2e',
    config = "require('vasco.mason')",
  }

  use { 'williamboman/mason-lspconfig.nvim', commit = 'd9365e72afb2f876a62cd3cade555dc1a95031d9' }

  use {
    'windwp/nvim-autopairs',
    commit = '0a18e10a0c3fde190437567e40557dcdbbc89ea1',
    after = { 'nvim-treesitter', 'nvim-cmp' },
    config = "require('vasco.autopairs')",
  }

  use {
    'davidgranstrom/nvim-markdown-preview',
    commit = '3d6f941beb223b23122973d077522e9e2ee33068',
    cmd = 'MarkdownPreview',
  } -- requires 'npm install -g live-server' and 'brew install pandoc'

  use {
    'jakewvincent/mkdnflow.nvim',
    commit = 'f98639be99a497ee0ccb78ec81ea6c8e7849f9db',
    ft = 'markdown',
    config = function()
      require('mkdnflow').setup {}
    end,
  }

  use { 'mzlogin/vim-markdown-toc', commit = '31aa38e58334f1321ae8ec6f38d05303f3226698', ft = 'markdown' }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    commit = '9d1f8dc1c8984e30efd8406aceba53dfadeaadbd',
    config = "require('vasco.null-ls')",
  }

  use {
    'jedrzejboczar/possession.nvim',
    commit = 'c138bbcd55d58d21ce12ceea8075dad29bea8c9f',
    config = "require('vasco.possession')",
  }

  use {
    'windwp/nvim-ts-autotag',
    commit = '044a05c4c51051326900a53ba98fddacd15fea22',
    config = "require('vasco.autotag')",
  }

  use {
    'folke/which-key.nvim',
    commit = 'bd4411a2ed4dd8bb69c125e339d837028a6eea71',
    config = "require('vasco.whichkey')",
    keys = { '<leader>' },
  }

  use {
    'norcalli/nvim-colorizer.lua',
    commit = '36c610a9717cc9ec426a07c8e6bf3b3abcb139d6',
    config = "require('vasco.colorizer')",
  }

  use { 'nvim-pack/nvim-spectre', commit = '58010388ff3cd6e52394183ce207659d2ae87753', event = 'VimEnter' }

  use {
    'rcarriga/nvim-dap-ui',
    commit = 'd33b905770f9c674468b0b83bed3aeab41cf9bb0',
    requires = {
      { 'mfussenegger/nvim-dap', commit = 'ad8b0de205a077b66cb301531bdc31c8fc7551b6' },
      { 'theHamsta/nvim-dap-virtual-text', commit = 'a36982259216afd710f55bcdc220477c74b5bc35' },
    },
    config = "require('vasco.dap')",
  }

  use {
    'TimUntersberger/neogit',
    commit = 'c9f3d44d2edfbb0bc6f8c5bb4366166e969b2e67',
    cmd = { 'Neogit' },
    config = "require('neogen').setup({ snippet_engine = 'luasnip' })",
  }

  use { 'rizzatti/dash.vim', commit = '25b17d9488454a1fcdbb2cbe829a23226f95e3c2', cmd = 'Dash' }

  use {
    'kyazdani42/nvim-tree.lua',
    commit = '09a51266bca28dd87febd63c66bdbd74f7764a63',
    config = "require('vasco.nvim-tree')",
    cmd = 'NvimTreeToggle',
  }

  use { 'kyazdani42/nvim-web-devicons', commit = '2d02a56189e2bde11edd4712fea16f08a6656944' }

  use { 'romainl/vim-cool', commit = '0ad6a212a910cef0aac7af244ee008ddd39a75c2', event = 'VimEnter' }

  use {
    'stevearc/dressing.nvim',
    commit = 'd886a1bb0b43a81af58e0331fedbe8b02ac414fa',
    requires = { 'MunifTanjim/nui.nvim', commit = '70f2dadb73b5aa15727ec8f7a620818997505be5' },
  }

  use {
    'nvim-lualine/lualine.nvim',
    commit = 'c0510ddec86070dbcacbd291736de27aabbf3bfe',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = "require('vasco.lualine')",
  }

  use {
    'terrortylor/nvim-comment',
    commit = 'e9ac16ab056695cad6461173693069ec070d2b23',
    config = [[require('nvim_comment').setup()]],
  }

  use {
    'kylechui/nvim-surround',
    commit = '22a25192ed98a937efe48b93c192a352d197c7e3',
    config = [[require('nvim-surround').setup()]],
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    commit = 'c15bbe9f23d88b5c0b4ca45a446e01a0a3913707',
    config = "require('vasco.indent')",
  }

  use {
    'sainnhe/gruvbox-material',
    config = "require('vasco.theme')",
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
