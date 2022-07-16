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
  use { 'wbthomason/packer.nvim', commit = 'e4c2afb37d31e99b399425e102c58b091fbc16be' }

  use { 'lewis6991/impatient.nvim', commit = '2aa872de40dbbebe8e2d3a0b8c5651b81fe8b235' }

  use { 'nathom/filetype.nvim', commit = 'b522628a45a17d58fc0073ffd64f9dc9530a8027' }

  use { 'neovim/nvim-lspconfig', commit = '0da8c129dc27e70770c3247c44988bbf0af6b1af' }

  use {
    'nvim-treesitter/nvim-treesitter',
    commit = '3bd228781bf4a927c5ceaf7a4687fed9f96d12b5',
    run = ':TSUpdate',
    config = "require('vasco.treesitter')",
    requires = {
      { 'jose-elias-alvarez/nvim-lsp-ts-utils', commit = '441385952278a1df5c91ba0d33e72c148d4654d3' },
      { 'JoosepAlviste/nvim-ts-context-commentstring', commit = '88343753dbe81c227a1c1fd2c8d764afb8d36269' },
      { 'RRethy/nvim-treesitter-endwise', commit = 'd618adae7e372df0e5413e8eaa1075b443cf594d' },
      {
        'lewis6991/spellsitter.nvim',
        commit = 'eb74c4b1f4240cf1a7860877423195cec6311bd5',
        config = function()
          require('spellsitter').setup()
        end,
      },
      {
        'p00f/nvim-ts-rainbow',
        commit = '9dd019e84dc3b470dfdb5b05e3bb26158fef8a0c',
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
    commit = 'bb6c3bf6f584e73945a0913bb3adf77b60d6f6a2',
    requires = 'nvim-lua/plenary.nvim',
    config = "require('vasco.gitsigns')",
    event = 'BufRead',
  }

  use {
    'sitiom/nvim-numbertoggle',
    commit = '8a6bdd34f40073d8bb813ea4eb2d68eb8366ca2a',
    config = function()
      require('numbertoggle').setup()
    end,
  }

  use {
    'tpope/vim-projectionist',
    commit = 'd4aee3035699b82b3789cee0e88dad0e38c423ab',
    config = "require('vasco.projectionist')",
  }

  use {
    'nvim-telescope/telescope.nvim', -- requires 'brew install rg' for live_grep
    commit = 'b79cd6c88b3d96b0f49cb7d240807cd59b610cd8',
    requires = {
      { 'nvim-lua/plenary.nvim', commit = '986ad71ae930c7d96e812734540511b4ca838aa2' },
      { 'nvim-telescope/telescope-fzy-native.nvim', commit = '7b3d2528102f858036627a68821ccf5fc1d78ce4' },
    },
    cmd = 'Telescope',
    config = "require('vasco.telescope')",
  }

  use {
    'nvim-neotest/neotest',
    commit = 'ee97820925ee633cbe2521ccffd7dbf80fa08f83',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
      { 'antoinemadec/FixCursorHold.nvim', commit = '5aa5ff18da3cdc306bb724cf1a138533768c9f5e' },
      { 'olimorris/neotest-rspec', commit = '3fb12ce28599df84ffdeecfd2310b7a46a769be1' },
      { 'haydenmeade/neotest-jest', commit = '12138a11525e62011cf0e57aee8a5e7c9f81e08c' },
    },
    config = "require('vasco.neotest')",
  }

  use {
    'hrsh7th/nvim-cmp',
    commit = '9897465a7663997b7b42372164ffc3635321a2fe',
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
    commit = '8f71a7c9d6155413f85df4a2350f59d0abd46dfc',
    requires = { 'rafamadriz/friendly-snippets' },
    config = "require('vasco.luasnip')",
  }

  use { 'onsails/lspkind-nvim', commit = '57e5b5dfbe991151b07d272a06e365a77cc3d0e7' }

  use {
    'williamboman/nvim-lsp-installer',
    commit = 'd2c5d9cef4bf310ed3e14e2a8a0dd0f0fec13ac8',
    config = "require('vasco.lsp-installer')",
  }

  use {
    'windwp/nvim-autopairs',
    commit = '972a7977e759733dd6721af7bcda7a67e40c010e',
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
    commit = 'a59b96c8b7c711ba30e0422689a3e61c0b0bd835',
    ft = 'markdown',
    config = function()
      require('mkdnflow').setup {}
    end,
  }

  use { 'mzlogin/vim-markdown-toc', commit = '31aa38e58334f1321ae8ec6f38d05303f3226698', ft = 'markdown' }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    commit = 'ec7764eb86bdae2f3a8fe31624aad67b8d814c71',
    config = "require('vasco.null-ls')",
  }

  use {
    'jedrzejboczar/possession.nvim',
    commit = 'c138bbcd55d58d21ce12ceea8075dad29bea8c9f',
    config = "require('vasco.possession')",
  }

  use { 'PlatyPew/format-installer.nvim', commit = 'bffe38fbd2453fd2a427363ed28a08c04d4fa6f2' }

  use { 'aserowy/tmux.nvim', commit = '7b19060fccfbd1791ae17ec2372e0bc836f9d519', config = "require('vasco.tmux')" }

  use {
    'windwp/nvim-ts-autotag',
    commit = '044a05c4c51051326900a53ba98fddacd15fea22',
    config = "require('vasco.autotag')",
  }

  use { 'echasnovski/mini.nvim', commit = '5ce21e729f3c7b6cff2c65b6540b154892e1b1c0', config = "require('vasco.mini')" }

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
      { 'mfussenegger/nvim-dap', commit = 'b9328b0cbd4dcbab29b1ce68f7103fe86a7703e1' },
      { 'theHamsta/nvim-dap-virtual-text', commit = 'a36982259216afd710f55bcdc220477c74b5bc35' },
    },
    config = "require('vasco.dap')",
  }

  use {
    'TimUntersberger/neogit',
    commit = 'f9b29244189ed4dab7b4a19e3245365a9d4e9249',
    cmd = { 'Neogit' },
    config = "require('neogen').setup({ snippet_engine = 'luasnip' })",
  }

  use { 'rizzatti/dash.vim', commit = '25b17d9488454a1fcdbb2cbe829a23226f95e3c2', cmd = 'Dash' }

  use {
    'kyazdani42/nvim-tree.lua',
    commit = '449b5bd0cbe08192ded83b2bce8cbec4764da63d',
    config = "require('vasco.nvim-tree')",
    cmd = 'NvimTreeToggle',
  }

  use { 'kyazdani42/nvim-web-devicons', commit = '2d02a56189e2bde11edd4712fea16f08a6656944' }

  use { 'romainl/vim-cool', commit = '0ad6a212a910cef0aac7af244ee008ddd39a75c2', event = 'VimEnter' }

  use {
    'stevearc/dressing.nvim',
    commit = '1e60c07ae9a8557ac6395144606c3a5335ad47e0',
    requires = { 'MunifTanjim/nui.nvim', commit = '70f2dadb73b5aa15727ec8f7a620818997505be5' },
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
